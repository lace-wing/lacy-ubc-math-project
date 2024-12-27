= Caveats
This package is still in development, so breaking changes might be introduced in the future (you are fine as long as you don't update the compile or the package version).

== `unsafe` Module
This template comes with a module called `unsafe`.
As obvious, use of its fields or functions is not safe --- may break the template.
This module is intended for debugging and 'tricks' only. Please make sure that you know what you are doing, should you decide to use it.

== Non-raw Student Number (`id`)
It is possible to use `str` or `content` as a student number for `author()`. This is to be compatible with possible non-numerical formats. When the field can be converted to plain text, it will be displayed as `raw`. Otherwise, the original content will be used, potentially causing inconsistencies. It is recommended that you use `int` or simple `str` for student numbers.

== Author Metadata
You are allowed to put `content` as an author's name, as there might be special characters or formatting in the name. However, should anything that Typst cannot convert to plain text be used, the part of the name would not be converted to plain text, and will be replaced by `<unsupported>` when converting to PDF metadata. In that case, you should provide the named argument `strname` to `author()` to specify a plain text version of the name.

