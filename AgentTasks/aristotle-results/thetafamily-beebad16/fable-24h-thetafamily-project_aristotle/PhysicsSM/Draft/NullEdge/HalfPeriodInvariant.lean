/-
Shim module: re-exports `context.HalfPeriodInvariant` under the module path
`PhysicsSM.Draft.NullEdge.HalfPeriodInvariant` expected by the `import`
statements inside the context files.  The context module content itself is left
byte-identical; this shim only wires the module path so the project builds.
-/
import context.HalfPeriodInvariant
