Project name: gate-c1-shifted-ckm-window-c174

You are Aristotle, working on the Null-edge / NullStrand Gate C1 program.

Current strategic context:
Gate C1 should be closed, if possible, by matching a null-edge overlap kernel to a known one-sector flavored-overlap reference. The leading branch Wilson candidate is

  W_branch^(1) = r (15 R - M_CKM)

where M_CKM should have values 15 on the zero corner and -1 on every nonzero corner. In the diagnostic case R = I, this should give W=0 at the physical corner and W=16r at all other corners.

Problem:
Prove a finite mass-window/sign-straddling theorem for the shifted CKM branch Wilson term.

Target theorem, diagnostic R=I version:
Assume r > 0 and 0 < m0 < 16r. If level(corner)=0 then

  W_branch^(1)(corner) - m0 < 0.

If level(corner)>0 then

  W_branch^(1)(corner) - m0 > 0.

Thus exactly one corner lies on the light/negative side and all 15 unwanted corners lie on the heavy/positive side, with explicit margin min(m0, 16r - m0).

Also formulate a general R-version:
Let R(corner) be a positive branch weight. Determine assumptions on R(0) and R(nonzero) under which the same one-sector sign split holds for

  r (15 R(corner) - M_CKM(corner)) - m0.

Requested output:
- Lean-ready theorem statements for the R=I case;
- a clean general-R assumption package;
- exact gap/margin formula;
- any monotonicity/positivity helper lemmas;
- explanation of how this theorem certifies the C159 MassWindow/SignStraddling obligation.

Do not use propagator-zero language. This is an inverse-kernel mass-window certificate.
