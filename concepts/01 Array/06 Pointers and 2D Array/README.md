# Pointers and 2D Array

```c
int a[3][3] = {6, 2, 5, 0, 1, 3, 4, 9, 8};
int *p;
```
|  p  |     | a[0][0] | a[0][1] | a[0][2] | a[1][0] | a[1][1] | a[1][2] | a[2][0] | a[2][1] | a[2][2] |
| :-: | :-: |   :-:   |   :-:   |   :-:   |   :-:   |   :-:   |   :-:   |   :-:   |   :-:   |   :-:   |
| 100 |     |    6    |    2    |    5    |    0    |    1    |    3    |    4    |    9    |    8    |
| 50  |     |   100   |   104   |   108   |   112   |   116   |   120   |   124   |   128   |   132   |

- `p = &a[0][0] = a[0]`

- `Print of p = a = &a[0][0] = &a = *a = a[0] = 100`

- `a + 1 = &a[1] = *(a + 1) = a[1] = &a[1][0] = 112`

- `*(a + 1) + 2 = 120 ,*(*(a + 1) + 2) = a[1][2] = 3`

- **`a[i][j] = *(a[i] + j) = *(*(a + i) + j)`**

- `a[1] + 1 = 116`, because `a[1]` is pointing to first element of array `a[1]` so adding `1` will incrase size by one element of that array.

- `&a[1] + 1 = 124`, because `&a[1]` is giving address of complete array `a[1]` so adding `1` will increase size by the size of that array.