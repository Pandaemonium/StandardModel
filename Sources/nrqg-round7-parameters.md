# Round 7: The Parameter Question

*Can the program derive any of the Standard Model's free parameters? Short answer: the question splits into tiers, and the honest tier assignments are more interesting than either "yes" or "no." One live numerical result below (§3) — run today against PDG data.*

---

## 0. The frame, and the graveyard warning

The SM has ~19 free parameters (26+ with neutrino masses and mixings). Deriving them is where physics programs go to die: the numerology graveyard runs from Eddington's 137 to a thousand arXiv preprints matching mass ratios to π's and φ's. The program's protection is the same discipline as always — pre-registration, gates, filed nulls — plus one triage rule: **a target relation is admissible only if it was discovered externally, predates precision data, or survives a pre-registered construction.** Pattern-matching our own numbers is forbidden.

"Derive" also means three different things, and conflating them is how programs lie to themselves:
- **Values** (compute α from first principles) — almost everything here is out of reach and says so;
- **Relations** (reduce the parameter count; boundary conditions at high scale) — several genuine angles;
- **Bins** (prove a parameter is derivable-in-principle vs. environmental/statistical vs. bedrock) — available for *everything*, and arguably the deepest deliverable: nobody else can even say which bin α is in.

---

## 1. Tier 0 — Already derived; the folklore forgets to count them

A generic anomaly-free chiral gauge theory has vastly more freedom than the SM exhibits. Several "would-be parameters" are already theorems in structures the program owns:

- **Electric charge quantization and the exactness of $Q_p + Q_e = 0$** — from compact holonomy groups on edges (Round 6 §6) and anomaly cancellation. In a generic QFT the electron/proton charge ratio is a dial; here it is exact.
- **Hypercharge assignments** — forced by anomaly freedom + the ℤ₁₆-completed multiplet; not chosen.
- **$N_c = 3$** — in the division-algebra fiber, unbroken color is the stabilizer of a complex structure inside the octonions: $\mathrm{SU}(3) \subset G_2$ as the subgroup fixing $\mathbb C \subset \mathbb O$ (the Furey-line result). The number of colors is the codimension structure of $\mathbb C$ in $\mathbb O$.
- **$\sin^2\theta_W = 3/8$ at the unification scale** — pure group theory of the Spin(10) embedding; the low-energy value is then running, not choice.

Tier 0's lesson: the parameter count was never really 19-of-equal-status. Some dials were welded decades ago, by exactly the structures (anomalies, compactness, division algebras) the tower is built from.

## 2. Tier 1 — Derivation-adjacent: quantitative relations the program natively inherits

**(a) Gauge coupling unification with an intermediate scale.** Non-SUSY SO(10) chains unify the three gauge couplings through an intermediate (Pati–Salam or left-right) stage at $\sim 10^{10\text{–}12}$ GeV. Three couplings → one coupling plus scales; and the intermediate scale is not decoration — it *is* the $\nu_R$ Majorana scale $M_R$. The erasability package (Round 5 §1.2) thus buys a quantitative chain:

**(b) The neutrino mass scale — a postdiction the program already owns.** Seesaw: $m_\nu \sim v^2/M_R$. With $M_R$ at the unification-forced intermediate scale, $m_\nu \sim 0.01\text{–}0.1$ eV — the observed window — and the Davidson–Ibarra leptogenesis bound ($M_R \gtrsim 10^9$ GeV) is comfortably satisfied by the same scale. One structure fixes the order of magnitude of seven "free" parameters (the ν sector) and the baryon asymmetry's mechanism.

**(c) Higgs sector boundary conditions — and a convergence worth staring at.** The spectral action (v2 §8.3, Chamseddine–Connes) does not treat $\lambda$ (Higgs quartic) and $y_t$ as free: they are tied to the gauge coupling at the unification scale as boundary conditions, then run down. The original prediction ($m_H \approx 170$ GeV) failed; the 2012 repair that brings it to $\approx 125$ GeV requires a real scalar singlet $\sigma$ — **which is the scalar of the $\nu_R$ Majorana sector.** Two completely independent lines of this program — the ℤ₁₆ erasability theorem and the spectral-action Higgs rescue — independently demand the same new sector at the same scale. Convergences of independent requirements are the strongest evidence a framework can generate internally.

**(d) Λ's order of magnitude** — owned since Round 2 (shot noise), live at DESI (commitment C4). And $\eta_B \sim 6\times10^{-10}$ becomes an *output* (leptogenesis, computable given the CP phases) rather than an input.

**New commitment C11 for the ledger:** the surviving SO(10) chains put proton decay within a few orders of Hyper-Kamiokande's reach. The program is on record that baryon number is violated (C6); Tier 1 sharpens where.

---

## 3. Tier 2 — Live targets: the Koide relation, executed today

**The datum.** Koide (1981): $Q \equiv \dfrac{m_e + m_\mu + m_\tau}{(\sqrt{m_e} + \sqrt{m_\mu} + \sqrt{m_\tau})^2} = \dfrac{2}{3}$.

Run today against PDG pole masses:

| Quantity | Value |
|---|---|
| $Q$ (measured) | 0.6666605 |
| $2/3$ | 0.6666667 |
| relative deviation | $9.2\times10^{-6}$ |
| $m_\tau$ predicted by $Q = 2/3$ | 1776.97 MeV |
| $m_\tau$ measured | 1776.86 ± 0.12 MeV (**+0.9σ**) |

The epistemic profile is exactly what §0's triage rule demands: discovered externally, in 1981, when $m_\tau$ was measured at 1784 ± 4 MeV — the prediction sat 2σ off, and two decades of improving data *moved to it*. This is not our pattern-matching; it is a forty-year-old successful prediction with no accepted explanation.

**Why it belongs to this program specifically.** Koide's relation has an exact geometric meaning: the vector $(\sqrt{m_e}, \sqrt{m_\mu}, \sqrt{m_\tau})$ makes an angle of exactly 45° with the democratic axis $(1,1,1)$. Equivalently, writing the parametrization $\sqrt{m_i} = \mu\,(1 + \sqrt2\cos(\delta + 2\pi i/3))$, $Q = 2/3$ holds *identically* for all $(\mu, \delta)$. Translated into the program's language: **Koide is the statement that two of the three Jordan invariants of $\sqrt M$ are locked** — $\mathrm{tr}(\sqrt M)^2 / \mathrm{tr}(M) = 3/2$ — **while the one remaining direction of freedom is precisely the cubic-norm direction: the program's degree-3 invariant** (Round 4, R4-2). The relation the leptons obey is a constraint on exactly the first two invariants of an element of $J_3$, with the third invariant left as the physical dial.

Fitting that dial today: $\delta = 0.222229$. Note, with the full suspicion it deserves, that $2/9 = 0.222222$ — agreement at $3\times10^{-5}$. This second layer (Brannen's observation) is *not* grandfathered by a prediction and stays firmly in the coincidence bin until a construction produces it; it is recorded, flagged, and not leaned on.

**Gate F2 (pre-registered).** In $J_3$ (real form first; octonionic after), classify the extrema of the general invariant potential
$$
V(X) = a\,\mathrm{tr}(X^2) + b\,(\mathrm{tr}\,X)^2 + c\,N(X) + \ldots
$$
Conjecture: the Koide orbit — $X = \mu(\mathbb 1 + \sqrt2\,F)$ with $F$ traceless of fixed norm (the "45° orbit," which contains the shifted primitive idempotents) — is extremal for an open set of couplings, making $Q = 2/3$ an *orbit condition* rather than a tuning, with $\delta$ (the cubic norm) as the residual modulus. This is finite commutative algebra: computable by hand or CAS, Lean-tractable, and equipped with a kill-condition — **if invariant potentials do not prefer the 45° orbit, F2 dies and Koide returns to the coincidence bin**, filed like everything else. Failure would also wound R4-2; the gate is honest in both directions.

**The generation pincer (companion argument).** Kobayashi–Maskawa: CP violation requires ≥ 3 generations; baryogenesis requires CP violation; observers require baryons [the lower jaw is selection-flavored and tagged Ω-adjacent]. The Jordan tower stops at $J_3(\mathbb O)$: ≤ 3 [structural]. **Three is the minimum that permits matter and the maximum the algebra allows.** A pincer with one soft jaw — stated at exactly that strength.

**Gate F3 (mechanism class only).** Yukawa *hierarchies* as fiber-hop counting: Froggatt–Nielsen is literally a suppression-by-graph-distance mechanism ($y \sim \varepsilon^{d}$), and the Wolfenstein parametrization's success ($\lambda \approx 0.22$ organizing the whole CKM matrix) is evidence that *some* single expansion parameter with combinatorial exponents underlies flavor. Named, low confidence, no numbers claimed.

---

## 4. Tier 3 — Honestly out of reach, with bin assignments

- **The value of α** (equivalently $g_U$): in the spectral picture, set by moments of the cutoff function — i.e., by the graph measure. Bin: **S or B** (substrate datum, like Λ's sign history), pending the growth measure. Not derivable today; *classifiable* today — which is more than any other framework offers for α.
- **The absolute Yukawa scale / $v/M_{\rm Pl}$** (hierarchy): 2/10, SOC direction only (Round 6 §7).
- **$\theta_{\rm QCD}$**: still 2/10; no native mechanism.
- **Individual CKM/PMNS angles beyond texture**: waits on F2/F3.
- **Absolute $m_e$**: the fully general case of the above; bin B today.

## 5. The scorecard

| Parameter(s) | Bin | Mechanism | Status |
|---|---|---|---|
| charge quantization, $Q_p/Q_e$ | **D** | compact holonomy + anomalies | done (Tier 0) |
| hypercharges | **D** | ℤ₁₆-completed multiplet | done |
| $N_c = 3$ | **D** | $\mathbb C \subset \mathbb O$ stabilizer | done |
| $\sin^2\theta_W(\Lambda_U)$ | **D** | Spin(10) group theory | done |
| $g_1, g_2, g_3$ → $g_U, M_U, M_R$ | **P** | unification chain | inherited, testable (C11) |
| $m_\nu$ scale (7 params' magnitude) | **P** | seesaw at $M_R$ | postdiction ✓ |
| $\lambda, y_t$ | **P** | spectral boundary conditions + σ | inherited; σ-convergence noted |
| Λ magnitude | **S** | shot noise | live at DESI (C4) |
| $\eta_B$ | output | leptogenesis | computable given phases |
| $N_g = 3$ | **P(C)** | Jordan cap + KM pincer | one soft jaw |
| Koide $Q = 2/3$ | **C** | 45° orbit in $J_3$ — **Gate F2** | piloted today, +0.9σ |
| Yukawa textures, Cabibbo | **C** | hop counting — Gate F3 | mechanism class only |
| α's value, $v/M_{\rm Pl}$, $\theta_{\rm QCD}$, absolute $m_e$ | **B/S** | growth measure | out of reach, binned |

## 6. Bottom line

Is it completely out of reach? No — and the honest inventory is: **four parameter-structures already derived** (Tier 0), **a relation web that fixes orders of magnitude and boundary conditions across the gauge–Higgs–neutrino sectors, with one genuine internal convergence** (the σ/ν_R sector demanded twice, independently), **one live gated target with a forty-year-old successful prediction behind it** (Koide, whose exact content — two locked Jordan invariants, cubic norm free — lands squarely on the program's own flavor conjecture), and **a bin classification for everything else**, including the humility rows. What no one should claim, and this program does not: a route to the *value* of α or the electron mass. Those wait on the growth measure — the same missing object that owns inflation and the hierarchy. The parameters are not a wall of nineteen mysteries; they are four theorems, one web, one gate, and one measure we have not found yet.

**Actions out of Round 7:** Gate F2 enters the slack-time queue directly behind Gate I1 (it is the same species of finite algebra, and it feeds R4-2 and paper P4). Commitment C11 (proton decay within the surviving SO(10) windows) enters the ledger. The Brannen δ stays in the recorded-coincidence file, untouched, until a construction earns it.
