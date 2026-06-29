# Gate C1 Aristotle completed integration: C121-C124, C126, C128-C129, C131, C133-C137

Date: 2026-06-27
Status: Summary integrated into the Gate C1 docs; standalone Aristotle artifacts are not yet promoted into trusted repo Lean.

## Executive result

The newest completed Aristotle round turns the Gate C1 problem into a much sharper overlap/sign-kernel program. The algebraic overlap/Ginsparg-Wilson layer is no longer the mystery: once a null-edge kernel supplies a gapped Hermitian or Krein-Hermitian sign involution, the GW relation, modified chirality, and projectors follow by finite matrix algebra. The remaining hard problem is therefore the seed-to-sign problem:

1. Build a gauge-safe, balance-odd finite seed `W_branch`.
2. Form a gapped kernel `H_ne = Gamma_K (D_ne + W_branch - m0 R)`.
3. Prove `T_br = sign(H_ne)` keeps nonzero `J`-odd content.
4. Prove the modified chirality trace survives the `Gamma_hat` defect.
5. Prove the bad sector has a true inverse-propagator gap, not a propagator zero.
6. Import anomaly/locality/index control from overlap/domain-wall physics or prove a null-edge analogue.

This is significant progress. Gate C1 is now much less amorphous: most of the finite algebra is formalizable, and the open work is concentrated into a short list of analytic/spectral and physical audit obligations.

## Integrated results

### C121: Riesz/spectral-island bridge

Project: `d277393d-d8c9-4676-b564-e97724ab2ddb`
Task: `f1e651d7-da45-4d3e-ba50-82f998455560`

Delivered a clean finite skeleton for branch-projector stability. Polynomial Riesz surrogates become true projectors exactly when the island interpolation condition holds. Continuous idempotent families have locally constant rank, giving the finite shadow of "rank cannot jump while the gap stays open." Gauge covariance of projectors follows from conjugation covariance of the kernel. The important caution is that nonzero origin chiral trace alone does not imply a stable branch island; a nilpotent counterexample has nonzero origin trace but no nontrivial isolated branch projector.

Use in Gate C1: finite origin diagnostics must be paired with a spectral-island/gap theorem. The next finite theorem should connect bad-sector inverse gaps and Schur-Feshbach resolvent control to the branch projector.

### C122: Schur/resolvent path-sum control

Project: `bb7b761d-cef4-42fc-8cf6-2083223d55bb`
Task: `eabd8970-7b5f-4c47-8661-6502e7f1f948`

Delivered a theorem stack for Neumann/resolvent expansions, path sums, shell-count tail bounds, oddness preservation under norm limits, and gauge covariance. The key usable result is that combinatorial shell-count control plus per-path amplitude control gives absolute convergence and a quantitative tail bound. If a finite partial odd contribution dominates the tail, nonzero oddness survives the infinite path sum.

Use in Gate C1: this supports the user's preferred path-integral/combinatorial framing. Locality does not have to mean strict ultralocality or even pure exponential decay; it can be controlled by summable path shells. The next job should compose this with the finite `J`-odd sign-kernel diagnostic.

### C123: finite matrix-valued Wilson origin criterion

Project: `241bd9cf-b2d1-41ef-90fe-bc7aff41cba7`
Task: `9990c2c1-b521-4507-ad6b-dd1f1a147295`

Formalized the finite criterion for matrix-valued Wilson/flavored-mass terms. If a term commutes with the balance involution `J`, its chiral trace vanishes under the C108 trace-cancellation relation. Nonzero chiral trace forces nonzero `Odd_J(W)`. A concrete Pauli witness shows a non-scalar balance-odd term can be a legitimate origin polarizer, while a non-scalar but balance-even term still fails. The Schur-channel parity rule says the effective Schur term is balance-odd exactly when the product of the three factor parities is `-1`.

Use in Gate C1: non-scalar is not enough. The load-bearing condition is `J`-oddness. This validates the matrix-valued Wilson direction but kills any merely non-scalar, balance-even variant.

### C124: overlap/Ginsparg-Wilson algebra for arbitrary Hermitian kernels

Project: `c65df36f-75bf-45f6-bae9-7fa768d3b221`
Task: `b6c79d4a-e108-482e-b1a5-140b20145f20`

Proved the finite overlap/GW algebra. Given chirality `Gamma` and a sign involution `epsilon`, the overlap operator `D = rho (1 + Gamma epsilon)` satisfies the GW relation, has a modified chirality `Gamma_hat`, and yields complementary chiral projectors. The pure algebra needs only involution identities; the analytic input is constructing `epsilon = sign(H)` from a gapped Hermitian kernel.

Use in Gate C1: the overlap algebra is solved once the sign kernel exists. We should stop treating GW as speculative and treat it as the reference algebraic interface.

### C126: Schur-generated matrix Wilson term

Project: `68710c7d-75f9-4134-b644-6620e54dc709`
Task: `2a4d67bf-802d-4ec5-8094-247a45edf809`

Derived the Schur parity criterion for an effective Wilson term `W_eff = V M^{-1} W`. If the graded parities multiply to `-1`, the Schur term is balance-odd. It also packaged Hermiticity/Krein-Hermiticity conditions for `H_ne`, origin Wilson/sign tests, a finite shadow of bad-sector projectors, and a toy witness with both origin tests nonempty.

Use in Gate C1: Schur/Feshbach generation is now a native way to get a balance-odd matrix Wilson term without arbitrary hand insertion. It also makes the ghost rule clearer: heavy-block invertibility gives exact elimination rather than propagator-zero mirror removal.

### C128: overlap-to-Gate-C1 translation

Project: `bbad005f-ce9e-4c29-a14f-f1497e350991`
Task: `40556473-9ad8-4fb9-a167-188653814e12`

Produced the reference-model translation table: standard Wilson kernel maps to `H_ne`; `sign(H_W)` maps to `epsilon_ne = sign(H_ne)` or `T_br`; the overlap Dirac operator maps to `D_ov,ne`; modified chirality and projectors transfer directly; spectral gap, locality, gauge covariance, anomaly/index, and bad-sector interpretation remain audits. It also proved the finite algebraic branch-selection transfer: any sign kernel satisfying the reference hypotheses gives the overlap branch-selection package.

Use in Gate C1: this strongly supports the user's preference to use a proven model and reinterpret it in null-edge language. The minimal null-edge theorem is an interface theorem, not a new exotic regulator.

### C129: candidate null-edge overlap kernel audit

Project: `ea3657b3-f2b9-492a-85fb-090addbefe35`
Task: `3c231479-ef7a-4000-aff4-2821485d501d`

Ranked candidate kernels. Candidate A, the branch-Wilson kernel `Gamma_K(D_ne + W_branch - m0 R)`, is the best first formalization target because it is the most direct Hermitian route into the already-proved overlap core. Candidate C, a domain-wall transfer Hamiltonian, is the most faithful reference-model reinterpretation because domain-wall-to-overlap physics is established. The job also proved candidate-independent GW superstructure and a finite origin odd diagnostic.

Use in Gate C1: pursue Candidate A as the cheap finite/Hermitian path while keeping Candidate C as import-mode/reference-model fallback.

### C131: origin balance audit for sign kernels

Project: `ab87465f-395b-4f33-8206-ca22afb59bff`
Task: `36af2704-f780-4512-8634-6c44a44581a4`

Formalized the origin diagnostic for `T = sign(H)` using `Odd_J(T)` and chiral occupation trace. If `H` commutes with `J`, then any polynomial/sign kernel of `H` also has vanishing `Odd_J`; therefore a `J`-symmetric kernel fails the diagnostic. A 2x2 witness passes the diagnostic, but the job also shows the diagnostic is not equivalent to the GW relation.

Use in Gate C1: the kernel itself must break balance in the right channel before `sign(H)` is taken. GW algebra alone cannot rescue a `J`-symmetric sign kernel.

### C133: qubit/qutrit origin factorization

Project: `e574db39-35b8-402c-a22f-125592c3268b`
Task: `11422d58-b7b3-4a14-a6ef-d7a3f742d0ba`

Formalized a finite origin-algebra audit for branch qubit times internal qutrit/spin factors. Identity-like internal selectors are balance-even and not polarizers. A Pauli-like branch factor is balance-odd and gives nonzero chiral trace when paired with a nonzero-trace internal factor. Gauge safety is expressed by internal centralizers or covariant intertwiners.

Use in Gate C1: Baez-style qubit/qutrit thinking is useful as an origin-algebra design principle, not as a standalone physical theory. It tells us to put chirality selection in the branch qubit while keeping gauge action in an internal centralizer.

### C134: gauge-safe branch-Pauli Wilson term

Project: `7a3c096b-0fcf-4010-84f0-1de56aeb1118`
Task: `3768ea63-bb99-4683-8cc8-80706f712492`

Proved that branch Pauli factors such as branch `sigma_z` or `sigma_y` are balance-odd against branch-swap `J = sigma_x`, while internal identity factors are gauge-safe. The minimal candidate `W = sigma_z_branch x (S x I_3)` is both balance-odd and gauge-safe against internal gauge actions. Internal-only terms are gauge-safe but balance-even and fail; noncentral qutrit factors can break gauge safety.

Use in Gate C1: this is the cleanest finite seed so far. It should be combined with the overlap sign kernel, the Schur-generation story, and the `Gamma_hat` protection audit.

### C135: high-level breakthrough strategy

Project: `de1282c5-9687-426a-a19e-52b6cc413828`
Task: `9f7611a9-01cc-4af4-861d-dcf929e4c44c`

Recommended the decisive sequence: balance-odd gauge-safe seed, true bad-sector gap/sign well-posedness, GW projector algebra, `J`-odd transfer through `sign`, and released-chirality protection against the C125 defect. It identifies the go/no-go theorem as a gauge-safe balance-odd dichotomy: either an Adams/flavored-mass-like null-edge term realizes the odd channel, or every gauge-safe candidate is balance-even and we should switch to import mode.

Use in Gate C1: prioritize kill-tests and transfer theorems over speculative new constructions.

### C136: finite flavored-overlap seed

Project: `ba3c72da-e6ca-49a1-be8f-c8c93f4b55fa`
Task: `58f95535-68a1-4507-87c1-92b7e742abd6`

Constructed an explicit 4-dimensional finite witness with an exact sign operator, nonzero `Odd_J(W_branch)`, nonzero `Odd_J(T)`, nonzero physical chiral trace, exact GW relation, nonzero protected `Gamma_hat` trace, and a true bad-sector gap. It also found that the smallest exact chirality-flavor mixed sign needs dimension 4 rather than 2. The caveat is crucial: with passive `P0 = 1`, the breakthrough conditions hold, but no rank-2 projector preserves all three conditions.

Use in Gate C1: this is the first explicit finite seed showing the whole overlap-style chain can work algebraically. The next question is whether it can be made gauge-safe/internal-qutrit-compatible and connected by homotopy to a reference overlap kernel.

### C137: Gamma_hat defect protection

Project: `4f09f8a2-18be-44c2-9c52-6b8870a74c2a`
Task: `3eb79ef1-4a57-4651-97c0-82bd0b138b4d`

Formalized sufficient conditions preventing the C125 modified-chirality defect from canceling the origin trace. If the defect term is strictly smaller than the origin trace, the released trace is nonzero. Structural alternatives include `R D P = 0`, balance-odd cancellation, or anticommutation/block-off-diagonal conditions. Counterexamples show the inequality must be strict; equality can cancel the released trace.

Use in Gate C1: every proposed finite seed now needs a `Gamma_hat` defect audit. The C136 seed passes in finite form; future jobs should prove robust survival under perturbation, Schur generation, and homotopy.

## Updated Gate C1 theorem obligations

The current proof chain should be treated as:

1. Origin seed: prove a gauge-safe, balance-odd `W_branch` exists on the finite origin algebra.
2. Schur generation: optionally derive `W_branch` as `V M^{-1} W` with parity product `-1` and heavy-block invertibility.
3. Kernel health: prove `H_ne = Gamma_K(D_ne + W_branch - m0 R)` is Hermitian or safely Krein-Hermitian and has a gap.
4. Sign transfer: prove `Odd_J(W_branch) != 0` leads to `Odd_J(sign(H_ne)) != 0`, at least under explicit finite dominance/gap hypotheses.
5. GW algebra: apply the existing overlap/GW finite algebra.
6. Gamma_hat protection: prove the C125 defect is zero or strictly dominated.
7. Bad-sector gap: prove the unwanted sector is gapped by inverse-propagator bounds, not removed by propagator zeros.
8. Reference-model inheritance: prove homotopy to standard overlap/domain-wall, or switch to explicit import mode.

## Highest-value next jobs

1. `J`-odd sign-transfer theorem: when does an odd Wilson seed survive functional calculus `sign(H)`?
2. Schur-Feshbach bad-sector gap theorem: convert heavy-block invertibility plus Schur gap into a true bad-sector inverse gap.
3. Gauge-safe dichotomy/classification: prove the centralizer has a balance-odd branch-Pauli channel, or prove it does not.
4. C136-to-qutrit lift: embed the finite 4-dimensional seed into branch x spin x qutrit with gauge-safe internal identity.
5. Homotopy/import theorem: transfer branch selection from standard overlap/domain-wall if a gapped homotopy exists.
6. Path-sum oddness survival certificate: compose C122 tail bounds with sign-transfer diagnostics.
