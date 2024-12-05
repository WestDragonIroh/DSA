# 2D Array

## Initialization

```c
int a[2][3];
int a[2][3] = {1, 2, 3, 4, 5, 6};
int a[2][3] = {{1, 2, 3}, {4, 5, 6}};
int a[][3] = {{1, 2, 3}, {4, 5, 6}}; //Valid
// int a[2][] = {{1, 2, 3}, {4, 5, 6}}; Not Valid
```

Giving size in first subscript is optional but the rest are mandatory.


|     |  0  |  1  |  2  |
| :-: | :-: | :-: | :-: |
|  0  | <table><thead><tr><th>a[0][0]</th></tr></thead><tbody><tr><td>1</td></tr><tr><td>100</td></tr></tbody></table> | <table><thead><tr><th>a[0][1]</th></tr></thead><tbody><tr><td>2</td></tr><tr><td>104</td></tr></tbody></table> | <table><thead><tr><th>a[0][2]</th></tr></thead><tbody><tr><td>3</td></tr><tr><td>108</td></tr></tbody></table> |
|  1  | <table><thead><tr><th>a[1][0]</th></tr></thead><tbody><tr><td>4</td></tr><tr><td>112</td></tr></tbody></table> | <table><thead><tr><th>a[1][1]</th></tr></thead><tbody><tr><td>5</td></tr><tr><td>116</td></tr></tbody></table> | <table><thead><tr><th>a[1][2]</th></tr></thead><tbody><tr><td>6</td></tr><tr><td>120</td></tr></tbody></table> |

Note: This is `row major` representation which is generally used. If we store column wise in memory then it's called `column major`.