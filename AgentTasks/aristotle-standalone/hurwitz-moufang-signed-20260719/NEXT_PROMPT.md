# Corrected Moufang-Artin gate

Target `HurwitzToolkit/Stage2Signed.lean`. The predecessor's unsigned
`associator_mul_right` is false in the octonions: an exact witness gives
opposite signs. Do not use that theorem or the predecessor's unfinished
`mul_right_moufang`.

First prove or refute the corrected signed associator statement. Then prove
`mul_right_moufang_clean` directly from alternativity, associator skew laws,
and the Teichmueller identity. If the signed helper is also wrong, replace it
only after providing a concrete counterexample and retain the valid Moufang
target. The final theorem must have only standard axioms. Run
`lake env lean HurwitzToolkit/Stage2Signed.lean`. Read `CONTEXT.md`.
