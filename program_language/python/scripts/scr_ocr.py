#!/bin/env python3

# 自动截屏并识别文字，以下三个变量需要修改
import pyautogui
import keyboard
import pytesseract

OUTPUT_FILE = 'output.txt'
SCREEN_REGION = (40, 118, 564, 700)     # x, y, width, height
pytesseract.pytesseract.tesseract_cmd = r'D:\application\tesseract\tesseract.exe'


def capture_and_recognize_text():
    screenshot = pyautogui.screenshot(region=SCREEN_REGION)
    img = screenshot.convert('L')
    # screenshot.save('test.png')

    text = pytesseract.image_to_string(img).strip()

    with open(OUTPUT_FILE, 'a', encoding='utf-8') as f:
        f.write(text + '\n')
    # for c in 'zt31j':
    #     pyautogui.press(c)


def main():
    print(f'Press 0 to recognize text')
    print(f'Press Esc to exit')

    keyboard.add_hotkey('0', capture_and_recognize_text)
    keyboard.wait('esc')


if __name__ == '__main__':
    main()
