# Rewriters-Ada
The Rewriters-Ada library
enables automatic rewriting of [Ada](https://en.wikipedia.org/wiki/Ada_(programming_language))
code based on concrete syntax.
The Rewriters-Ada library is build on top of the 
[Rejuvenation-Ada library](https://github.com/TNO/Rejuvenation-Ada)
and smoothens the manipulation process by functionality
that combines and repeats rewrites
and enables post processing of manipulated code, such as simplifications and pretty printing.

The example tool [Code Reviewer](code_reviewer) shows how the Rewriters-Ada library can be used.

Rewriters-Ada is part of the [Renaissance-Ada project](https://github.com/TNO/Renaissance-Ada) 
that develops tooling for analysis and manipulation of Ada code.

## Examples

Snippets from diff made with [Code Reviewer](code_reviewer)
```diff
   function Release_Only (Mode : Operation_Mode) return Boolean is
-     (case Mode is when Release_Size_Mode | Release_Speed_Mode => True, when others => False);
+     (Mode in Release_Size_Mode | Release_Speed_Mode);
```

```diff
- if Valid then
-    Add (Value, 0, 0, 0);
- else
-    Add ("", 0, 0, 0);
- end if;
+ Add ((if Valid then Value else ""), 0, 0, 0);
```

```diff
- for Acf of Acfs loop
-    if Acf = null then
-       return False;
-    end if;
- end loop;
- return True;
+ return (for all Acf of Acfs => Acf /= null);
```

Example based on
[aws](https://github.com/AdaCore/aws/blob/7488c0f6f4c593b51e8b61b94d245e2ff4896e33/config/ssl/aws-net-ssl__openssl.adb#L215-L216)
code
```diff
-   Max_Overhead : Stream_Element_Count range 0 .. 2**15 := 81 with Atomic;
-   for Max_Overhead'Size use 16;
+   Max_Overhead : Stream_Element_Count range 0 .. 2**15 := 81 with
+      Atomic,
+      Size => 16;
```

[![Alire](https://img.shields.io/endpoint?url=https://alire.ada.dev/badges/rewriters.json)](https://alire.ada.dev/crates/rewriters.html)
