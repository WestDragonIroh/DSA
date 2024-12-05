# Array and Pointers


## Array

Let's take a array.

```c
int a[] = {6, 2, 1, 5, 3};
```

It is represented in memory as following.


| a[0] | a[1] | a[2] | a[3] | a[4] |
| :--: | :--: | :--: | :--: | :--: |
|  6   |  2   |  1   |  5   |  3   |
| 100  | 104  | 108  | 112  | 116  |

Here `a` is both name and pointer to base value.

`printf("%p", a) = 100`


## Pointer

Let's take integer b and pointers p and q.

```c
int b = 10;
int *p = &b;
int *q;
q = a
```

|  b   |  p   |  q   |
| :--: | :--: | :--: |
|  10  | 200  | 100  |
| 200  | 240  | 300  |

`*` is used to dereference pointer and get value.  
```
*p = 10
p++ = p + (size of data type of p)
p++ = 200 + 4(size of int) = 204
```


## Similarities

- ```
  i = 2
  a[i] = *(a + i) = *(q + i) = q[i] = i[a] = q[i]
## Diffrences

- `q++` is valid but `a++` is not because we can't change base address of array.
- In case of array, name of array is address of array. But it's not same for pointer.
- ```
  a = &a
  q != &q
## Important points

```
  a + 1 = 104
  &a + 1 = 120
  &a[0] + 1 = 104
  *(a + 1) = 2
  *a + 1 = 7
```