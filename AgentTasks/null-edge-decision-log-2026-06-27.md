# Null-edge decision log - 2026-06-27

This log records the major pivots that replaced the longform working plan now
archived at [`Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md`](../Sources/Archive/Null_Edge_Unified_Mass_Model_Working_Plan_Longform_2026-06-27.md).

## D1. Central language

Decision:

```text
Use mass as canonical quadratic obstruction.
Do not use universal spectral gap or universal Plucker spread.
```

Reason:

```text
The P1 Plucker theorem is a finite state invariant/rest-frame obstruction, not
always an operator spectral gap. Spectral gap is correct only for operator,
Hessian, Hamiltonian, or mass-matrix contexts.
```

## D2. Claim labels

Decision:

```text
Representation, reconstruction, structural theorem, prediction.
```

Reason:

```text
The project is currently strong as reconstruction and structural theorem work.
Prediction requires a codimension or rank-deficit result.
```

## D3. P1 boundary

Decision:

```text
P1 proves the finite Plucker/null-spinor mass identity and should not depend on
P1.5, P2, Furey, Gate C, or continuum success.
```

Reason:

```text
This keeps the first paper publishable and claim-safe.
```

## D4. Super-Dirac sign convention

Decision:

```text
D = i D_N + Gamma_s Phi_H
D^2 = -K_null - C_diamond - T_frame + Phi_H^2
      - i Gamma_s sum_a C_a [nabla_a, Phi_H]
```

Guardrail:

```text
Phi_H is chi_E-odd internally and Gamma_s-even for this sign convention.
```

## D5. Double-counting rule

Decision:

```text
Plucker/null spread is kinetic-side.
Phi_H^2 is internal zero-order mass block.
On shell, K_null equals an eigenvalue of Phi_H^2.
Do not add them as two independent masses.
```

## D6. Gate C Route A failed

Decision:

```text
Bare OperatorForcesAlignment is no longer the target.
```

Reason:

```text
The actual four-component null Clifford symbol has two-dimensional,
chirality-balanced raw branch kernels.
```

New target:

```text
OperatorForcesAlignmentAfterProjection.
```

## D7. Gate C release criteria

Decision:

```text
Gate C releases only with nodal control, branch projectors, one-dimensional
projected kernels, aligned projected chirality, Krein positivity, ghost-zero
safety, and species-splitting/moduli audit.
```

Reason:

```text
Determinant-zero branches, off-branch zeros, cyclotomic witnesses, Krein signs,
and Golterman-Shamir ghost hazards are independent blockers.
```

## D8. Furey/Baez role

Decision:

```text
Furey/Baez/DVT supply the finite internal algebraic half, not the external
kinetic solution.
```

Use for:

```text
Gate H internal spectrum;
anomaly inheritance;
gauge group quotient;
internal grading;
legal Phi_H/Yukawa maps;
possible texture/codimension constraints.
```

Do not use for:

```text
bare Gate C release;
Krein positivity;
ghost-zero safety;
continuum convergence;
QCD confinement;
numerical Yukawa values.
```

## D9. Furey/Baez prediction test

Decision:

```text
The sharp Gate F Furey test is an IntertwinerCodimensionAudit.
```

Question:

```text
Does the legal Furey/Baez/DVT Phi_H/Yukawa intertwiner space have smaller
freedom than generic SM Yukawa moduli?
```

## D10. FMS/gauge language

Decision:

```text
Do not say local gauge symmetry literally breaks as an observable fact.
Use covariant internal reference section, stabilizer, orbit stiffness, and
finite gauge-invariant composites.
```

## D11. Gate D path

Decision:

```text
Start with positive DEC/Hodge-Dirac and connection-Laplacian proxies before
full Lorentzian/Krein/retarded continuum claims.
```

## D12. QCD boundary

Decision:

```text
QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
Do not define B_QCD or claim proton-mass derivation until a finite color-gap or
confinement theorem exists.
```
## D13. Gate C v3 release target

Decision:

```text
Do not release Gate C for bare D_+.
Release Gate C, if possible, for a regulated/projected physical operator D_phys.
```

Preferred candidate:

```text
W(q) = sum_a (1 - cos q_a)
R_W = (r / (2h)) sum_a (2 - T_a - T_a^sharp)
```

Reason:

```text
W(q) vanishes only at the physical origin on the real torus, so every non-origin
real determinant zero receives regulator cost. Near the origin, R_W is
irrelevant to the leading Dirac symbol.
```

Claim label:

```text
regulated reconstruction / branch-control counterterm, not prediction unless r
and the operator form are forced.
```

Open audits:

```text
operator placement and Gate A sign behavior;
gauge-covariant link dressing;
overlap/domain-wall/projected physical-sector construction;
Krein-positive retained sector;
post-gauge residue/ghost safety.
```

## D14. Gate C moved up one layer

Decision:

```text
D_+ is a raw retarded null-edge kinetic seed, not the released physical chiral
operator.
```

New release object:

```text
PhysicalSectorData =
  (B_phys, P_phys, R, Gamma_phys, J_phys, H_sf, Locality, GhostSafe)
```

Gate C should release, if at all, for:

```text
D_phys built from D_+, physical-sector data, and a legal spectral-flow or
projection construction.
```

Reason:

```text
The bare symbol has chiral-balanced branch kernels, determinant-zero nodal
curves, off-branch zeros, and Krein/chirality mismatch. Asking the raw seed to
be the physical chiral operator is the wrong layer.
```

## D15. RA-doubled flavored-Wilson overlap candidate

Decision:

```text
The next serious Gate C candidate is a retarded/advanced doubled,
flavored-Wilson overlap-style construction, not a bare Wilson correction.
```

Candidate ingredients:

```text
D_RA =
  [ 0       D_+ ]
  [ -D_+^* 0   ]

M_lift =
  r W
  + mu (I - T_br) / 2
  + lambda (I - F_tet)

H_NED(m) =
  Gamma_hat_sE (D_RA + M_lift - m I)
```

Interpretation:

```text
W lifts non-origin real-torus zeros such as q_star.
F_tet is the tetrahedral CKM-style flavor scalar.
T_br is the decisive branch-flavor involution needed to separate unwanted
branch germs that touch or approach the origin.
```

Hard caveat:

```text
Scalar Wilson positivity is a branch-lifting lemma, not a chirality theorem.
It does not change the Gamma_s-balanced origin fiber.
```

Failure criterion:

```text
If no local/gauge-covariant T_br exists, CKM-style flavored overlap cannot
release Gate C for the current seed.
```

## D16. Non-circular spectral flow and ghost-zero rule

Decision:

```text
Do not apply sign(H) to a merely Krein/J-self-adjoint operator.
```

Release requirement:

```text
H_sf must be genuinely Hermitian/self-adjoint in a positive physical Hilbert
structure and gapped before an overlap sign function is used.
```

Ghost-zero rule:

```text
No gauge-charged branch may be removed solely by a zero of its propagator or by
a vanishing point-split numerator.
```

Preferred finite free check:

```text
For every lifted unwanted branch region,
sigma_min(D_RA(q) + M_lift(q) - m_0) >= g > 0.
```

Reason:

```text
Golterman-Shamir-style propagator zeros can behave as gauge-coupled ghost
states. A true inverse-propagator gap is the safer finite target.
```

## D17. Gate H forbidden-operator target

Decision:

```text
Furey/Baez/DVT can make Gate H prediction-relevant by forcing the legal finite
Dirac/Phi_H block form, not by deriving Yukawa values.
```

Best near-term target:

```text
Every chi_E-odd, J_F-real, first-order, gauge-covariant finite Dirac/Higgs
operator has the SM Yukawa block form

Phi_H = Phi(Y_u, Y_d, Y_e, Y_nu, M_R)

with arbitrary generation matrices and no leptoquark, diquark, proton-decay,
wrong-hypercharge, or colored-Higgs blocks.
```

Claim label:

```text
structural/codimension theorem, if forbidden blocks vanish from the finite
algebraic axioms rather than manual deletion.
```

Non-claims:

```text
No Yukawa magnitudes, ranks, mixings, or hierarchies are derived.
Gate H does not solve Gate C unless a new theorem couples branch idempotents to
internal idempotents.
```

## D18. Global gauge and right-handed neutrino guardrails

Decision:

```text
The finite matter representation can be shown to factor through the Z6 central
quotient, but local field data alone should not be claimed to force Nature's
global gauge form.
```

Right-handed neutrino rule:

```text
Pure gauge/anomaly data do not force nu_R.
Specific finite-triple or ideal-closure axioms may include or force it.
```

## D19. Gate C split into C0 and C1

Decision:

```text
Split Gate C into:

Gate C0: external species health.
Gate C1: physical chiral release.
```

Gate C0 asks for:

```text
origin retained;
all non-origin real-torus branches gapped by an inverse-propagator mass gap;
leading null-edge symbol unchanged;
free propagator-zero ghosts excluded.
```

Gate C1 asks for:

```text
physical chirality grading;
positive physical sector;
retained origin branch chiral in that grading;
gauge/Krein/ghost/counterterm clauses.
```

Reason:

```text
Scalar Wilson positivity may solve the species-health problem in the
retarded/advanced double, but it does not make the origin branch chiral.
Calling that a full Gate C release would be a category error.
```

Immediate finite theorem:

```text
If A^dagger = -A and m > 0, then A + m I is invertible and has singular value
bounded below by m.
```

Application:

```text
A = D_RA(q), m = r W(q).
For real q != 0, W(q)>0, so D_RA(q) + r W(q)I is gapped.
```

Claim label:

```text
possible Gate C0 release, not Gate C1 or full Gate C.
```

## D20. C73 null-Wilson gauge-covariance theorem

Decision:

```text
Treat NullEdgeNullWilsonGaugeCovariance.lean as C0-supporting infrastructure.
```

What it supplies:

```text
finite link-dressed Wilson regulator;
gauge covariance under source/target link transformations;
Hilbert self-adjointness of the symmetric T + T^sharp placement;
flat recovery of (r/h) sum_a (1 - cos q_a).
```

What it does not supply:

```text
origin chirality;
Gate C1 release;
post-gauge ghost safety;
overlap locality;
full physical Gate C release.
```

## D21. C0 Wilson positivity target

Decision:

```text
The next finite C0 theorem after C73 is Wilson positivity and kernel
characterization in gauge backgrounds.
```

Target:

```text
For unitary dressed shifts T with Hilbert adjoint T^sharp,
2 - T - T^sharp = (I - T)^sharp (I - T).
```

Consequences:

```text
The Wilson quadratic form is a sum of squared edge defects.
It is positive semidefinite.
Its zero sector is the common covariantly constant sector.
```

Claim label:

```text
C0 gauge-robustness theorem.
Not a C1 chirality theorem and not full Gate C release.
```

## D22. C87 split audit correction

Decision:

```text
C0 plus Gate H is not enough for the Standard Model-facing chiral release.
```

Reason:

```text
In the factorized architecture H_N tensor H_F, branch/chirality data on the
external factor and internal Gate H data factorize. If the external origin
sector has chiral index zero, then the total factorized index is zero.
```

Claim language:

```text
C0 may make the external seed species-healthy.
C1 is still required for a nonzero physical chiral index.
Gate H certifies internal legality and anomaly/Yukawa structure, not external
branch chirality.
```

## D23. C88 taste-only origin no-go

Decision:

```text
Taste-only involutions scalar on the origin corner cannot polarize the origin
kernel.
```

Consequence:

```text
Origin polarization requires a non-taste/spinor-line auxiliary layer: projected
Weyl, domain-wall, overlap, or another physical-sector construction.
```

## D24. H9 Gate H forbidden-operator roadmap

Decision:

```text
Start Gate H finite Dirac classification with the cheap gauge+grading
forbidden-block lift.
```

LegalFiniteDirac clauses:

```text
chi_E-odd;
Gamma_s-even;
J_F-real;
gauge-covariant under the true SM quotient/covering data;
order-one / conjugate-ideal compatible.
```

Important split:

```text
Gauge equivariance kills wrong-hypercharge and colored-Higgs blocks.
Leptoquark, diquark, and proton-decay blocks require order-one plus J_F/ideal
structure, not gauge alone.
```

## D25. Observer-conditioned mixedness + branch-topology upgrade

Decision:

```text
Adopt two explicit but linked layers: (i) invariant finite Plucker spread `det(P)`;
(ii) observer-conditioned mixedness via visible reduction `rho = P_vis / Tr(P_vis)` and chosen kinematic frame.

Also reframe Gate C as a branch-topology/sheaf problem before coefficient tuning:
`Z = {q : det D_+(q)=0}`; release is about admissible physical-sheet selection with true gaps.
```

Consequence:

```text
Public-facing and internal summaries should avoid scalar-Wilson release language for Gate C1 and should log any Gate C release in terms of nodal control + kernel projection + ghost-safe mass-gap + chirality alignment.
``` 
