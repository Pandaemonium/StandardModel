Lane B (division algebra -> SM). AUDIT + attempt one of the 3 open `s o r r y`s in
the Spin(10) stabilizer / Selector-Theorem draft program
(`PhysicsSM/Draft/Spin10Stabilizer{Iso,Selector,Transitivity}.lean` or similar).
This is the "16 of Spin(10) = one generation" track. Goal: for each of the 3
sorries (isomorphism / transitivity / selector), give a precise audit
(is the statement TRUE, what is the exact missing lemma, is it convention-matched,
what is the cleanest route), and CLOSE whichever is most tractable.

START: read the Spin10Stabilizer draft files + `Sources/` notes on the Krasnov /
pure-spinor Spin(10) track. Check with `lake env lean`. If broader build stalls,
SKIP.

Deliver: (1) a per-sorry audit (TRUE/FALSE/underspecified, missing lemma, route);
(2) close the most tractable sorry with a kernel-checked proof if feasible, else a
tightened handoff. Flag any convention mismatch or false statement (a
kernel-checked negative is a first-class result). No new axiom / native_decide /
weakening. If lake build stalls, SKIP; return the audit + any proof.
