/-
Shim module: re-exports `context.ModeInvariantHalfWinding` under the module path
`PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding` expected by the `import`
statements inside the context files (which reference this project path).  The
context module content itself is left byte-identical; this shim only wires the
module path so the project builds on a case-sensitive filesystem.
-/
import context.ModeInvariantHalfWinding
