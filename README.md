# m-m-v-b
## MULTIPLE-MULTIPLE-VALUE-BIND for Common Lisp

Just when you need to accomodate multiple multiple value lists.

Sample usage:

```common-lisp
(m-m-v-b ((a b c) (foo)
          (d e f) (bar)
          (g h i) (baz))
  (list a b c d e f g h i))
```
