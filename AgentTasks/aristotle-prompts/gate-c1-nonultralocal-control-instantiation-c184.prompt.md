Project name: gate-c1-nonultralocal-control-instantiation-c184

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current status:
C156 gives path-shell summability control. C171R proves a sign function alone does not imply locality/control. Gate C1_NU requires an explicit non-ultralocal control certificate for the released overlap/sign kernel or reference import.

Task:
Design the concrete NonultralocalControl instantiation for the null-edge overlap/sign kernel.

Requested output:
1. A path-shell certificate: finite propagation or shell decomposition, shell count bound, amplitude/operator norm bound, summability, and tail-to-zero theorem.
2. A resolvent/sign-kernel certificate: conditions under which sign(H) or a Riesz projector admits controlled expansion from a gapped kernel.
3. A bridge theorem showing how standard overlap admissibility/locality can supply or imply a GateC1_NU control certificate.
4. A clear distinction between exponential locality, summable path-shell control, power-law/regulated control, and declared nonlocal fallback.
5. Lean-ready API structures and theorem statements.

Do not infer control merely from the existence of sign(H). Do not require strict ultralocality.
