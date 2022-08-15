#ifndef __SERIALIZER_H__
#define __SERIALIZER_H__

#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>
#include <exception>
#include <cstdlib>
#include <cassert>
#include <cerrno>
#include <cstring>
#include <string>

class wsStream {
public:
    enum class DataVersion : uint32_t {
        V_INVALID = 0,
        V0,
        V1,
        V_TOTAL
    };

    wsStream(size_t len=0) : len_(len) {}

    void SetVersion(DataVersion v) {
        version_ = v;
    }

    DataVersion GetVersion() const { return version_; }

    void Stop() {
        if (fd_ == -1) {
            return;
        }
        // 申请共享内存大小应和实际写入一致
        assert(abs(cur_pos_ - mem_head_) == len_);
        munmap(mem_head_, len_);
        close(fd_);
        fd_ = -1;
    }

    void Move(size_t len) {
        cur_pos_ += len;
        assert(abs(cur_pos_ - mem_head_) <= len_);
    }

    void Waste() {
        cur_pos_ = mem_head_ + len_;
    }

  protected:
    char *mem_head_;
    char *cur_pos_;
    int fd_;
    size_t len_;
    DataVersion version_ = (DataVersion)(((uint32_t)DataVersion::V_TOTAL) - 1);
};

class wsIStream :public wsStream {
  public:
    wsIStream(const char *file) {
        fd_ = open(file, O_RDONLY);
        if (fd_ == -1) {
            auto msg = strerror(errno);
            throw std::exception();
        }
        len_ = lseek(fd_, 0, SEEK_END);
        mem_head_ = (char*)mmap(nullptr, len_, PROT_READ, MAP_SHARED, fd_, 0);
        if (mem_head_ == MAP_FAILED) {
            close(fd_);
            auto msg = strerror(errno);
            throw std::exception();
        }
        cur_pos_ = mem_head_;
    }
    ~wsIStream() {
        Stop();
    }
    bool IsNull() {
        sizeof(nullptr_t);
        for (int i = 0; i < sizeof(nullptr); ++i) {
            if (*(cur_pos_ + i) != 0) {
                return false;
            }
        }
        Move(sizeof(nullptr));
        return true;
    }

    wsIStream& operator>>(bool& value) { return operator>>((uint8_t&)value); }
    wsIStream& operator>>(uint8_t& value) { return PlainRead(value); }
    wsIStream& operator>>(uint16_t& value) { return PlainRead(value); }
    wsIStream& operator>>(int32_t& value) { return PlainRead(value); }
    wsIStream& operator>>(uint32_t& value) { return PlainRead(value); }
    wsIStream& operator>>(size_t& value) { return PlainRead(value); }
    wsIStream& ReadMemory(void *mem, size_t len) {
        memcpy(mem, cur_pos_, len);
        Move(len);
        return *this;
    }

  private:
    template <typename T>
    wsIStream& PlainRead(T& value) {
        value = *((T*)cur_pos_);
        Move(sizeof(T));
        return *this;
    }
};

class wsOStream :public wsStream {
  public:
    wsOStream(const char *file, size_t len) : wsStream(len) {
        fd_ = open(file, O_RDWR | O_CREAT);
        if (fd_ == -1) {
            auto msg = strerror(errno);
            throw std::exception();
        }
        system((std::string("chmod 600 ") + file).c_str());
        mem_head_ = (char*)mmap(nullptr, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd_, 0);
        if (mem_head_ == MAP_FAILED) {
            close(fd_);
            auto msg = strerror(errno);
            throw std::exception();
        }
        ftruncate(fd_, len);
        // int cur_len = lseek(fd_, 0, SEEK_END);
        // if (cur_len < len) {
        //     lseek(fd_, len - 1, SEEK_SET);
        //     write(fd_, "", 1);
        // }
        cur_pos_ = mem_head_;
    }
    ~wsOStream() {
        Stop();
    }

    wsOStream& operator<<(nullptr_t) { 
        for (int i = 0; i < sizeof(nullptr); ++i) {
            *this << (uint8_t)0;
        }
        return *this;
    }
    wsOStream& operator<<(bool value) { return operator<<((uint8_t)value); }
    wsOStream& operator<<(uint8_t value) { return PlainWrite(value); }
    wsOStream& operator<<(uint16_t value) { return PlainWrite(value); }
    wsOStream& operator<<(int32_t value) { return PlainWrite(value); }
    wsOStream& operator<<(uint32_t value) { return PlainWrite(value); }
    wsOStream& operator<<(size_t value) { return PlainWrite(value); }
    wsOStream& WriteMemory(const void *mem, size_t len) {
        memcpy(cur_pos_, mem, len);
        Move(len);
        return *this;
    }

  private:
    template<typename T>
    wsOStream &PlainWrite(T value) {
        *((T*)cur_pos_) = value;
        Move(sizeof(T));
        return *this;
    }
};

#endif // __SERIALIZER_H__