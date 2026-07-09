# Proof: CP-oddness + celestial solid angle of the Bargmann triple (Conjecture D closer)

Context: a finite null-edge program has the gauge-invariant Bargmann/Pancharatnam
triple B(psi1,psi2,psi3) = <psi1|psi2><psi2|psi3><psi3|psi1> already proved phase-
gauge-invariant (invariant under independent unit-phase rescalings of each ray). This
is the correct CP-holonomy object (the raw WEDGE triple is NOT phase-gauge-invariant).
Two pieces remain to make CP-as-holonomy a theorem.

Targets:
1. bargmann_CP_odd: under CP-conjugation (componentwise complex conjugation of the
   spinors), the Bargmann triple maps to its complex conjugate, so arg(B) -> -arg(B);
   hence Im(B) != 0 is a genuine, non-gaugeable CP-violating invariant.
2. bargmann_solid_angle: the phase arg(B) equals (up to sign) HALF the solid angle of
   the geodesic triangle on the celestial (Bloch) sphere spanned by the three
   directions n1,n2,n3 (the Pancharatnam/Berry-phase geometric identity). Prove the
   exact finite identity relating arg(B) to the spherical-excess / solid angle of the
   Bloch-vector triangle (use the Bloch representation rho_i = (1 + n_i . sigma)/2).

Kernel-checked only, no sorry/admit/axiom/native_decide, in-file print axioms guard,
footprint [propext, Classical.choice, Quot.sound], Mathlib only. You may restate the
Bargmann triple self-containedly. Deliver Lean + honest ARISTOTLE_SUMMARY.md (the
CP-oddness, the solid-angle identity or its precise obstruction).
