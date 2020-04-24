﻿// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

// Get All Dependencies
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        Foo(3, "Hello");
        Bar("World");    // Different as call in Foo
        Baz("!");        // Same as call in Foo
    }

    operation Foo<'A, 'B>(a : 'A, b : 'B) : Unit {
        Bar(a);
        Baz(b);
    }

    operation Bar<'X>(x : 'X) : Unit { }

    operation Baz<'Y>(y : 'Y) : Unit { }
}

// =================================

// Argument Resolution
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        Foo(3);
    }

    operation Foo<'A>(a : 'A) : Unit { }
}

// Foo.A -> Int

// =================================

// Type List Resolution
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        Foo<Int>();
    }

    operation Foo<'A>() : Unit { }
}

// Foo.A -> Int

// =================================

// Argument and Type List Resolution
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        Foo<Int>(3);
    }

    operation Foo<'A>(a : 'A) : Unit { }
}

// Foo.A -> Int

// =================================

// Partial Application One Argument
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        (Foo(_))(3);
    }

    operation Foo<'A>(a : 'A) : Unit { }
}

// Foo.A -> Int

// =================================

// Partial Application Two Arguments
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        (Foo(_, 3))(1.);
    }

    operation Foo<'A, 'B>(a : 'A, b : 'B) : Unit { }
}

// Foo.A -> Double
// Foo.B -> Int

// =================================

// Complex Partial Application
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        (Foo<String, _, _>(_, _, 3))("Hello", 1.);
    }

    operation Foo<'A, 'B, 'C>(a : 'A, b : 'B, c : 'C) : Unit { }
}

// Foo.A -> String
// Foo.B -> Double
// Foo.C -> Int

// =================================

// Nested Partial Application
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        Foo((Bar(_))(3));
    }

    operation Foo<'A>(a : 'A) : Unit { }

    operation Bar<'B>(b : 'B) : 'B { return b; }
}

// Foo.A -> Int
// Bar.B -> Int

// =================================

// Operation Returns Operation
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        (Bar())(3);
    }

    operation Foo<'A>(a : 'A) : Unit { }

    operation Bar<'B>() : ('B => Unit) { return Foo<'B>; }
}

// Foo.A -> Bar.B
// Bar.B -> Int

// =================================

// Operation Takes Operation
namespace Microsoft.Quantum.Testing.TypeParameterResolution {

    operation Main() : Unit {
        Bar(Foo<Int>, 3);
    }

    operation Foo<'A>(a : 'A) : Unit { }

    operation Bar<'B>(op : ('B => Unit), b : 'B) : Unit { }
}

// Foo.A -> Int
// Bar.B -> Int