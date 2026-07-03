# Gate Q2 discrete QNEC: numerical protocol and calibration plan

Date: 2026-07-02.
Track: paper-level numerics (no Lean dependency; small instances may be
Lean-checked later).
Provenance: `Sources/NERD_3.md` A3 and `Sources/NERD_2.md` section 6,
upgraded by `Sources/NERD_4.md` section 7 (Peschel-exact method, vacuum
subtraction, checkerboard geometry). Paper target: P3.

## Statement being tested

Discrete QNEC conjecture (2d form): for free fermions on a 1+1d null-edge
chain with null cut at strand position `s`,

```text
2 pi a^2 <T_kk(s)>  >=  Delta^2 S(s) + (6/c) (Delta S(s))^2 - O(a^#)
```

where `Delta^2 S(s) = S(s+1) - 2 S(s) + S(s-1)` is the discrete second
difference of the outside entropy along null cut deformations, matching
Wall's 2d QNEC in the continuum limit, with the discretization-error
exponent `#` to be measured.

Split enforced by the v2.1 review (state it loudly in the paper):

- **Q1 (exact, free):** positivity and monotonicity of the vacuum-subtracted
  relative entropy `S_rel(s) = Delta<K_s> - Delta S_s` along nested cuts are
  exact finite-dimensional theorems (Uhlmann/Petz data-processing). They are
  not evidence for QNEC.
- **Q2 (the content):** QNEC is the SECOND difference - convexity of
  `S_rel` along null deformations - and is not free. This is what the
  numerics probe.

## Method (all exact linear algebra, no Monte Carlo)

Gaussian (free) fermion technology throughout:

1. Build the ground state (or quenched state) of the free fermion chain;
   all information is in the two-point correlation matrix
   `C_ij = <c_i^dagger c_j>`.
2. For a region `A`, restrict `C` to `A`; entanglement entropy is
   `S(A) = -sum_k [ nu_k log nu_k + (1 - nu_k) log (1 - nu_k) ]` over the
   eigenvalues `nu_k` of the restricted matrix (Peschel's method).
3. Entanglement/modular Hamiltonians for the discrete first-law companion
   measurement come from `K_A = log((1 - C_A)/C_A)`; the Eisler-Peschel
   line of work gives the lattice Bisognano-Wichmann comparison.
4. Geometry: nested causal diamonds along a null ray of the 1+1
   checkerboard lattice (discrete-time walk geometry). The null cut at
   strand position `s` splits the chain; deform the cut along the null
   direction only. This ties Q2 to the repo's checkerboard thread and to
   the I3.5 zitterbewegung frequency.
5. `T_kk` discretization: define the null-null component from the lattice
   stress tensor of the free fermion; document the operator-ordering and
   point-splitting choices explicitly (they are the main systematic).

## Run plan (three regimes, in order)

1. **Massless calibration (run first).** 2d CFT: continuum QNEC is
   SATURATED, so the discrete deficit isolates pure lattice artifacts.
   Deliverables: the discretization exponent `#`; the size of the
   `(6/c)(Delta S)^2` term on the lattice; a calibrated counterterm
   prescription if needed.
2. **Massive.** Strict inequality expected; measure the gap against the
   concurrence mass of Gate I1/A1 (the same `m` that sets the I3.5 clock).
3. **Quenched/excited states.** Stress-test the inequality away from
   vacuum.

Companion measurement (Gate G1'.2's numerical shadow): the discrete first
law `delta S = delta <K>` on lattice causal diamonds, using the same
correlation-matrix machinery.

Second companion measurement (Gate D3, added 2026-07-02): the modular
defect functionals of `Sources/Null_Edge_Dynamics_Gate_D.md` section 3.3 -
the inclusion-leak defect `leak(s, t)` (norm of the block of the cut-s
modular flow that drives modes of the nested algebra `A_{s+1}` back across
the cut, for `t >= 0`) and the Bisognano-Wichmann defect `bw(s)`
(kernel distance from the Eisler-Peschel discretized boost). Both are
functions of the correlation matrices already computed for the entropy
ladder; report their lattice-spacing scaling exponents alongside the QNEC
deficit. Finite half-sided inclusions are provably trivial (Gate D3.0), so
nonzero defects at finite spacing are expected; the physics is entirely in
the rate at which they vanish.

## Deliverable framing (pre-registered; all three outcomes are papers)

- Calibrated discrete QNEC (inequality holds with measured artifacts).
- Counterterm-modified QNEC (holds after a documented lattice counterterm).
- Finite-spacing violation (a discovery about what discretization does to
  QNEC, constraining every discrete-spacetime program).

Upside: if the Gaussian discrete QNEC can be PROVED (plausible - continuum
free-field proofs exist and Gaussian entropy formulas are exact), it is a
candidate first discrete-native quantum energy condition theorem and a
candidate first machine-verified energy condition. The proof attempt comes
after the numerics, and is the technical rehearsal for the P9 moonshot.

## Preconditions and checks

- **Literature check (resolves the N=8* asterisk before submission):**
  confirm that no lattice-native QNEC formulation with systematic
  discretization analysis exists. Use the null-edge paper collections
  (`Scripts/lit/neo4j_paper_search.py --query`, then `--chunks` for
  anything that looks close). If the niche has closed, reframe as a
  reproduction + formalization target.
- **Scooping risk (R2):** the numerics are cheap; front-run with an arXiv
  note as soon as the massless calibration is clean.
- **Q1 library check:** before formalizing any DPI statement, check
  Lean-QuantumInfo and PhysLean for finite DPI / relative entropy layers.

## Implementation notes

- Python + numpy; exact diagonalization only. Keep system sizes small
  enough for machine-precision cross-checks and large enough to fit the
  scaling exponent (a few hundred sites is plenty in 1+1d).
- Home: `Scripts/qnec/` (new), with fixture outputs recorded under the CAS
  and oracle policy (tool name, version, generation command, input
  conventions, output format, license status, CI status). A CAS/numerics
  fixture can justify a test, never an unproved trusted theorem.
- Record every convention choice (fermion discretization, boundary
  conditions, cut definition, `T_kk` ordering) in a header block of the
  script and in the task note; these are exactly the places a referee will
  probe.
