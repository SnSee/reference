
# CSS

## 用法

```css
/* 如设置所有details左侧缩进20像素 */
details {
    margin-left: 20px;
}


/* 如设置class为class_id的details左侧缩进20像素 */
.class_id {
    margin-left: 20px;
}
<details class="class_id">
    ...
</details>


/* 如设置class为class_id下的所有details左侧缩进20像素 */
.class_id details {
    margin-left: 20px;
}
<div class="class_id">
    <details>
        ...
    </details>
</div>
```

## CSS属性

<https://www.w3school.com.cn/cssref/css_selectors.asp>
