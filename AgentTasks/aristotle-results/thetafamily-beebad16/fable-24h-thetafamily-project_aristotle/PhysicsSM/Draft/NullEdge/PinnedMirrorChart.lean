/-
Shim module: re-exports `context.PinnedMirrorChart` under the module path
`PhysicsSM.Draft.NullEdge.PinnedMirrorChart`.  The context module content itself
is left byte-identical; this shim only wires the module path so the project
builds.
-/
import context.PinnedMirrorChart
