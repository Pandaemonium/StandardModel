/-
Shim module: re-exports the landed context engine module under the module path
`PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding` expected by the import line
inside `context/HalfPeriodInvariant.lean`.  This makes the landed context build
resolve without editing any context module (the context files are left
byte-identical to how they landed).  All declarations live in the namespace
`PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding`, which this module brings
into scope transitively.
-/
import context.ModeInvariantHalfWinding
