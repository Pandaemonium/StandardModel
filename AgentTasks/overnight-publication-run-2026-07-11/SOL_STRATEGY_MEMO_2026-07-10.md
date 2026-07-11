# Sol strategy memo (received 2026-07-10 ~20:30 PDT via user; archived verbatim)

After looking at the paper more closely and comparing its open problems with
the surrounding quantum-walk and lattice-fermion landscape, I think the
conversation uncovered a stronger research program than either "a novel mass
coin" or the broad slogan "physics is information."

The most promising formulation is this:

> Invariant mass measures the mixedness or distinguishability of
> null-direction information; the complex Pluecker phase is connection or
> orientation data; and the quantum walk converts both into reversible
> propagation.

That statement has three fairly precise mathematical layers. Two are already
almost present in the paper. The third can be built naturally from its
unfinished many-body construction.

## 1. The deepest information-theoretic interpretation

The paper begins with P = sum_i psi_i psi_i^dagger, mu^2 = det P
= sum_{i<j} |psi_i wedge psi_j|^2. For two spinors, z = psi wedge phi gives
the rest operator B_z = [[0, z],[zbar, 0]], B_z^2 = mu^2 I. That is the
paper's central verified construction.

Now normalize the total momentum matrix: T = tr P, rho = P / T. Because P is
a positive 2x2 matrix, rho is literally a qubit density matrix. For any
unit-trace 2x2 matrix, det rho = (1 - tr rho^2) / 2. Therefore

  mu^2 / T^2 = det rho = (1 - tr rho^2) / 2,
  mu / T = sqrt((1 - tr rho^2) / 2).

This is a very clean result:

- A single null direction gives a pure qubit state, so tr rho^2 = 1 and
  mu = 0.
- Several perfectly aligned null directions still give a pure state and zero
  mass.
- Non-collinear null directions create a mixed qubit state and a nonzero
  rest gap.
- In the rest frame, where the spatial momentum vanishes, the normalized
  momentum matrix is maximally mixed.

Using the standard Pauli identification P = E I + p . sigma, we have
T = 2E, det P = E^2 - |p|^2 = m^2, and rho = (1/2)(I + (p/E) . sigma).
Consequently

  m / E = sqrt(2 (1 - tr rho^2)) = sqrt(1 - |p|^2 / E^2).

So relativistic rest content is exactly qubit mixedness, after fixing the
total energy normalization. That is much sharper than saying "mass is
information." It says: mass is a specific spectral measure of the
incompatibility of the occupied null directions.

### Operational distinguishability

For two spinors, |psi wedge phi|^2 = |psi|^2 |phi|^2 - |<psi, phi>|^2.
Writing normalized states as psihat and phihat,

  mu = |psi| |phi| sqrt(1 - |<psihat, phihat>|^2).

For pure qubit states, D(psihat, phihat) = sqrt(1 - |<psihat, phihat>|^2)
is their trace distance. Hence mu = |psi| |phi| D(psihat, phihat). With the
usual null-momentum normalization |psi|^2 = 2 E_1 and |phi|^2 = 2 E_2,

  mu = 2 sqrt(E_1 E_2) D.

That gives mass an operational interpretation: after energy weighting, it is
the optimal quantum distinguishability of the two null directions.

For many spinors, if p_i = |psi_i|^2 / T and
rho = sum_i p_i |psihat_i><psihat_i|, then

  mu^2 / T^2 = sum_{i<j} p_i p_j (1 - |<psihat_i, psihat_j>|^2).

So the invariant mass squared is an ensemble-weighted sum of pairwise
quantum distinguishabilities.

This would make an excellent, tightly scoped companion paper: "Invariant
Mass as Qubit Mixedness and Null-Direction Distinguishability." Pluecker
coordinates have appeared before in quantum-information treatments of
entanglement (e.g. arXiv:quant-ph/0507070), so the novelty claim would have
to focus specifically on the exact bridge from null-momentum ensembles to
Lorentzian mass, the canonical rest operator, and operational state
discrimination - not on using Pluecker coordinates in quantum information
generally.

## 2. A new three-layer interpretation of z

Let M = [psi phi]. Then P = M M^dagger and z = det M. Normalize the matrix
amplitude: A = M / sqrt(tr P). Now rho = A A^dagger, so A is an amplitude or
purification of the density matrix rho. Moreover det A = z / tr P. Thus:

- |det A| measures the mixedness of the momentum qubit.
- arg det A is orientation information in the choice of amplitude or
  factorization.
- B_z converts that oriented amplitude into a rest operator.
- The unitary coin converts the rest operator into actual propagation and
  turning amplitudes.

Three layers: (one) observable momentum information rho = P / tr P, whose
mixedness gives the mass-to-energy ratio; (two) factorization/purification
information P = M M^dagger, where right multiplication M -> M R (R in U(2))
leaves P unchanged while z -> z det R, so the phase of z lives in the
determinant U(1) part of the factorization freedom; (three) dynamical
realization, where the walk promotes z -> B_z -> exp(-i a B_z), converting
factorization geometry into directed amplitudes.

## 3. The most important conceptual question: when is the phase physical?

At constant z the paper is explicit that replacing z by |z| gives the same
one-particle spectrum up to unitary conjugation. But there is a subtle point
that should become a theorem rather than remain interpretive: psi ->
e^{i alpha} psi, phi -> e^{i beta} phi does not change either null momentum,
while z -> e^{i(alpha+beta)} z. So the phase of a single constant z is not
automatically an observable. It may simply be factorization gauge.

The correct question is: which combinations of the phase survive all allowed
rephasings and are therefore observable? Expected answer: a nonzero phase
field on a simply connected region is locally removable; a constant phase is
pure basis choice; a phase gradient produces link variables after local
chiral rotation; a globally trivial link field is still pure gauge;
closed-loop holonomy, winding around zeros, boundary data, or relative
phases among several mass sectors can be physical.

Two target theorems:

> Gauge-triviality theorem. On a simply connected finite region where
> z(x) /= 0, every single-species Pluecker mass field is locally unitarily
> equivalent to a positive real mass field plus a pure-gauge endpoint
> connection.

> Defect theorem. Nonzero winding of the phase around a closed loop forces
> either a zero of z, nontrivial transition data, or an obstruction to a
> global gauge fixing.

## 4. The most promising near-term physics paper: Pluecker defects and localized modes

The zero set of z is a physically distinguished defect set (collinearity of
the primitive spinors). Sequence: 1D real sign wall (audit BOTH quasienergy
0 and pi, Floquet); 2D vortex z(r, phi) = f(r) e^{i n phi}, f(0) = 0, with a
finite-lattice index or parity statement relating winding n to localized
states; eventually 3D line defects and walls. Suggested title: "Topological
Defects of a Pluecker-Derived Dirac Mass in an Exactly Unitary Quantum
Walk." The central result should be an exact finite index, transfer-matrix
theorem, or robustness theorem, not merely a numerical localized mode.
(Topological quantum walks have a mature defect literature, e.g.
arXiv:1811.09520; the new element is the derived origin of the mass field.)

## 5. The best rigorous version of "the field is the sum over paths"

For a one-particle unitary U, the free fermionic Fock evolution Gamma(U)
satisfies <y_1...y_n| Gamma(U) |x_1...x_n> = det [U_{y_i x_j}]. Each entry
is a sum over directed histories, so the determinant expands into a signed
sum over collections of histories: a free fermionic amplitude is an
antisymmetrized coherent sum over families of Pluecker-weighted histories.

Program: prove Gamma(UV) = Gamma(U) Gamma(V); unitary U implies unitary
Gamma(U); creation and annihilation covariance; causal-cone inheritance for
local fermionic observables; substitute the exact z/zbar history sum into
the determinant formula; derive the multi-history expansion with fermionic
signs. Then add the quartic pair kick as a genuine vertex. First nontrivial
calculation: a two-particle scattering matrix or bound-state condition
(interacting fermionic cellular automata with bound states exist, e.g.
arXiv:2304.14687). Suggested title: "Pluecker-Weighted Fermionic History
Sums and a Local Pair Interaction."

## 6. The 3+1 regulator problem: narrower and more constructive framing

Stop modifying the Pluecker mass coin; the obstruction sits in the spatial
factorization architecture. Any repair must change at least one of:
separability into independent x/y/z factors; range one; one factor per axis;
four-dimensional internal space; a one-period drive; or the requirement that
extra modes disappear rather than become controlled flavors.

Formulate as matrix Laurent-polynomial synthesis: U(q) = sum_{r in R} U_r
e^{i r . q} with all-momentum unitarity, U(0) = I, dU/dq_j(0) = -i alpha_j,
rotational constraints, and explicit conditions excluding +-1 eigenvalues
away from the intended point. Candidate families: (a) coupled same-range
spatial terms (abandon per-axis factorization); (b) enlarged unit cell /
ancilla-assisted Wilsonization (couple physical channels to gapped
auxiliaries; effective Wilson mass r sum_j (1 - cos q_j) in the physical
block; prove ancilla bands stay away from 0 and pi); (c) multistep Floquet
drives (audit the full Floquet spectrum); (d) accept controlled flavors
(flavor-staggered covering maps); (e) relax strict to exponential locality
(overlap / Ginsparg-Wilson style, cf. hep-lat/9808010). The landed exact
tests (corner aliases, body-center modes, determinant polynomials, continuum
tangent, Wilson gap) should become the automated objective suite for the
search, followed by exactification and Lean verification. (Existing
doubler-free constructions per arXiv:2601.15885 change the architecture -
stay amplitudes - and retain residual modes, so they do not close this
paper's precise problem.)

## 7. The mass field can become dynamical, but three theories hide in that phrase

(A) geometric frame field (spinors as frame data, z an order parameter);
(B) bosonic composite field (add kinetic term and potential for z);
(C) fermion condensate (primitives become operator fields, z a bilinear
expectation). These are physically different; choose the ontology before
writing an action. The scale problem is real: the homogeneous action
selects only t = 0 (proved). Honest options: explicit symmetry-breaking
potential (supplies v); fixed normalization tr P = Lambda (at fixed trace,
maximizing det P selects P proportional to I - balanced directions - while
Lambda supplies the scale); dimensional transmutation (hard, needs genuine
many-body RG); strong-coupling condensate (gap equation). One complex
scalar z is not the Standard Model Higgs; the natural bridge is
matrix-valued.

## 8. Matrix-valued Pluecker masses: flavors and chiral structure

Replace scalar z by Z : V_R -> V_L with B_Z = [[0, Z],[Z^dagger, 0]];
B_Z^2 = diag(Z Z^dagger, Z^dagger Z); singular values are rest masses;
Z -> g_L Z g_R^dagger is exactly the chiral mass/Yukawa transformation
form. Questions: can several primitive sectors produce a canonical Z; do
singular values give hierarchy; do singular vectors give mixing; which
phases survive independent rephasings; can several Pluecker matrices give
CP-sensitive invariants? Classification target: all continuous, local,
equivariant polynomial maps from primitive null-spinor data to Z whose odd
Hermitian operator has the relativistic square.

## 9. Where the Jordan algebra could enter

After matrix-Z, not before. Use the exceptional-Jordan stabilizer
description of the SM gauge group (Baez-Schwahn, arXiv:2606.15235) to
specify the local internal-state algebra; identify qubit/qutrit
subalgebras; determine stabilizers on edge/cell degrees of freedom;
classify chiral modules; classify equivariant Pluecker maps; ask what is
forced. The Jordan algebra does not supply spatial locality, causal
updates, continuum limits, anomaly cancellation, doubling solutions, or
couplings - the QCA supplies dynamics and locality.

## 10. Renormalization may explain the split family's refusal to close

The pure mass subgroup closes under temporal blocking; the ordered split
does not - that is telling you what the effective coupling space wants to
be. Track: Pluecker mass, mixed-axis operators, Wilson-like terms, higher
derivatives, ordered commutator terms, vertices, phase holonomies. (Formal
setting: renormalisation of fermionic cellular automata,
arXiv:2511.23398.) Key question: is the Pluecker rest operator relevant
under coarse-graining while its phase holonomy is topological/marginal?

## 11. The continuum PDE completion: less glamorous, strategically important

Define explicit sampling/interpolation maps S_a, I_a and prove
I_a U_a^{floor(t/a)} S_a f -> e^{-i t H_D} f strongly in L^2 for a stated
class; then extend to regular z(x, t). The safest technical companion.

## 12. A revised publication ladder

- Minimal publishable paper: invariant mass as qubit mixedness and
  distinguishability (the identities of section 1 + the det-U(1) gauge
  identification).
- Strong target paper: Pluecker phase, gauge classification, defects, and a
  localized mode (local gauge triviality away from zeros; loop
  holonomy/winding; wall or vortex index; exact localized 0- or
  pi-quasienergy mode; robustness).
- Second target: fermionic second quantization as Pluecker-weighted
  multi-history sums + local pair interaction, with a two-particle
  bound-state or scattering calculation.
- Reach: matrix-valued Pluecker mass operators and flavor geometry.
- Parallel high-risk engineering: a globally gapped 3+1 Pluecker-Dirac walk
  beyond separable range-one architecture (constrained matrix-polynomial
  synthesis).
- Very high risk: a dynamical Pluecker order parameter.
- Knock-it-out-of-the-park program: one finite framework where local
  information algebras determine internal symmetries; Pluecker invariants
  generate matrix mass couplings; gauge connections arise from local frame
  changes; fermionic fields are antisymmetrized history networks; species
  are stable sectors; a controlled continuum limit yields interacting
  chiral QFT; and at least one observed structural feature is derived, not
  fitted.

## 13. What to avoid claiming too early

Not "mass is entropy" (the exact statement concerns purity, determinant,
pairwise distinguishability under fixed normalization). Not "the constant
phase of z is observable" (identify the rephasing gauge; construct loop,
defect, boundary, interaction, or multi-flavor invariants first). Not "the
path sum is the quantum field" (field amplitudes admit exact coherent
multi-history representations). Not "z is the Higgs" (no SM representation,
gauge couplings, vacuum dynamics, or scale selection yet). Not "a universal
3+1 no-go" (the landed no-gos exclude a narrow but important architecture).
Do not let the unsolved 3+1 regulator delay the geometric,
information-theoretic, defect, or many-body results.

## Overall judgment

The primitive objects may be null-direction amplitudes. Their
gauge-invariant mixture determines rest mass. Their factorization
orientation determines connection data. Local unitary evolution turns those
data into coherent histories. After second quantization, fermionic fields
are represented by antisymmetrized families of those histories, and
particles appear as stable excitation patterns of the resulting local
dynamics.

The most intelligent next move: prove the phase-gauge classification and a
Pluecker defect mode, while writing the information-theoretic mixedness
theorem as a compact companion result.
