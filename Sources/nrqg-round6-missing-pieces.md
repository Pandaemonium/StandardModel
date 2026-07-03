# Round 6: What We Were Missing

*A systematic gap audit of the whole stack (v2, Rounds 3–5, It-from-Commit, the Tower), with lateral fills. Three structural holes found and filled, one master principle unified, one new architectural layer added, one dangerous theorem confronted, and several small leaks patched. Tags as before: [T]/[M]/[C]/[Ω].*

---

## 1. Hole #1 — Dynamics. Filled by the node bootstrap.

**The gap.** The entire stack is kinematics, free operators, and inequalities. Nowhere does it say *why the forces are these forces*: why Yang–Mills, why universal gravitational coupling, why not spin-3 messages. The tower derived the stage and the actors but not the script.

**The fill [T].** The script is not chosen; it is *forced* — and the theorems that force it are native to the graph because they live entirely on null legs:

- **Weinberg's soft theorems (1964).** Consistency of soft massless spin-1 emission forces coupling to *conserved charges* (charge conservation is not an input); soft massless spin-2 forces *universal* coupling to energy–momentum — the equivalence principle as a theorem; soft spin ≥ 3 admits no consistent long-range coupling at all.
- **Four-particle consistency (Benincasa–Cachazo; McGady–Rodina).** Gluing on-shell three-point amplitudes into four-point objects consistently (BCFW) forces: self-interacting spin-1 couplings to satisfy the **Jacobi identity** (Lie algebras are derived, not postulated), spin-2 to be the unique graviton with GR's structure, and nothing above spin 2 with finitely many species.

Since NRQG's nodes *are* on-shell three-point data on null legs (v2 §1.4), these results transplant as **node self-consistency conditions on the graph**: the only consistent node decorations are Yang–Mills vertices over some Lie algebra, one universal graviton mode, and Yukawa-type scalar couplings. New tower level between kinematics and matter:

$$
\boxed{\;\text{Level 3.5: the dynamics is the unique consistent decoration of the null graph.}\;}
$$

**[Ω] The It-from-Commit glosses write themselves, and they are exact.** The Jacobi identity is *associativity of message routing* — three-way handoffs must not depend on bracketing order. And the equivalence principle: gravity couples to energy, and energy is the clock budget (§1 of the essay) — **the scheduler prices demand, not process type; congestion pricing is type-blind, hence everything falls identically.** The deepest principle of general relativity is the statement that a load balancer cannot see what a process is, only how much it runs.

**Gate NB1.** Transplant the four-point consistency computation onto tetrahedral null kinematics symbolically; verify Jacobi-from-consistency in the graph-native variables. Medium effort, high leverage: it would make Level 3.5 [M] rather than borrowed [T].

---

## 2. Hole #2 — Spin-statistics and PCT. Filled by modular covariance.

**The gap.** Fermions everywhere in the program; no spin-statistics theorem anywhere. Also no PCT. These are usually *assumed* on lattices. Embarrassing for a framework claiming completeness — and the fill was sitting in our own Round 3.

**The fill [T].** Guido–Longo (algebraic QFT): if the wedge algebras satisfy **modular covariance** — the modular flow of the vacuum on a wedge is the boost (the Bisognano–Wichmann property) — then the **spin-statistics connection and the PCT theorem follow**. No Lagrangian, no canonical quantization: modular structure alone.

Round 3's result A1 is precisely a finite Bisognano–Wichmann property (the modular Hamiltonian of the soldered momentum state *is* the boost). The program's route to spin-statistics is therefore already under construction: it rides the Gate I2 → F-M2 chain (finite modular theory → type-II crossed-product continuum). When the wedge-modular structure lands, spin-statistics and PCT are *inherited theorems*. And the three-J taxonomy (v2 §8.2) pays its dividend: **the PCT operator is the modular conjugation $J_m$ of the wedge.** The third J was never bookkeeping; it was the antimatter map.

**[Ω]** Antimatter, in commit language: every wedge ledger admits exactly one modular reflection, and antiparticles are matter read in that reflection — sessions replayed by the wedge's own mirror. CPT invariance is the statement that the ledger and its modular mirror carry the same physics: the one discrete symmetry the architecture cannot break, because it is not a symmetry *of* the content but of the *reading*.

**Gate SS1.** Formalize the conditional: (Bisognano–Wichmann on graph wedges) ⟹ (statistics fixed by spin), in the cleanest available finite/1+1d shadow. Conditional theorems are still theorems; the hypothesis is exactly what F-M2 is for.

---

## 3. Hole #3 — Weinberg–Witten. Confronted, dodge documented.

**The gap — and this one was dangerous.** The Weinberg–Witten theorem forbids a massless spin-2 particle composite of a Lorentz-covariant QFT with a covariant conserved stress tensor. Every emergent-gravity program dies here unless it names its dodge, and five rounds of documents never mentioned it. A referee would have.

**The dodge [M], now on the record, two independent layers.** (i) The graph is not Lorentz covariant per sample — only in distribution (v2 §4.2). WW's hypotheses fail at the substrate exactly the way they fail for phonons on a crystal; unlike the crystal, the symmetry is statistically exact, so no observable violation leaks (Round 5, C3). (ii) The equation-of-state route (v2 §6) never introduces a graviton operator in the matter Hilbert space at all: the metric is a sufficient statistic, and gravitons are collective hydrodynamic modes of the ensemble, not particles composited from matter. Both layers independently void the theorem's premises.

**The cost, honestly:** dodging WW obligates the program to *exhibit* the graviton as a collective mode with the right propagator. Registered as **Gate G1′.5**: linearized spin-2 collective excitation of the null-graph ensemble with the correct two-point structure. Failure mode **F-WW** enters the ledger: if the ensemble's collective modes cannot reproduce a massless spin-2 pole (statistically), the gravity sector fails regardless of the entropic derivation.

---

## 4. The master principle: everything irreversible lives on the null cone

The scattered monotones across the stack turn out to be one object viewed from different floors — and the unification is itself a discovery about what the program *is*.

**[T] The inventory.** Monotonicity of relative entropy / strong subadditivity, applied to *null-deformed regions*, yields: the **ANEC** (Faulkner–Leigh–Parrikar–Wang), the **QNEC** (Ceyhan–Faulkner) — the gravity sector; the **entropic c-theorem** in d=2 and **F-theorem** in d=3 (Casini–Huerta, with null-cone/boosted-interval constructions); and the **a-theorem** in d=4 (Casini–Testé–Torroba), whose proof runs on SSA for regions on the light cone plus the **Markov property of the vacuum on null planes**: the vacuum saturates SSA on null cuts — conditional mutual information exactly zero, every null slice exactly recoverable from the previous (Petz recovery is perfect there and only there).

So: gravitational attraction, and the irreversibility of renormalization flow — the two great one-way streets of physics — are the *same inequality*, and the special surfaces on which the inequality lives are null. Add Round 5's complexity thread (the second law of complexity; the CA growth bound $\propto 2E/\pi\hbar$ — literally Margolus–Levitin — with black-hole interiors as complexity made geometric, Stanford–Susskind), and the program's identity statement sharpens:

$$
\boxed{\;\text{The universe runs on monotones, and its monotones run on the null cone. NRQG makes the null cone primitive.}\;}
$$

**[Ω] The Markov property is the architecture speaking.** "The vacuum is a quantum Markov chain along null cuts" is, in commit language: *null slices are complete checkpoints* — each carries everything needed to reconstruct the next, nothing carried over out-of-band. A message-passing substrate would produce exactly this signature, and it is a *theorem* that our vacuum has it. Of everything found this round, this is the result that most looks like the graph leaving a fingerprint on the continuum.

**RG, finally in the tower [T→M].** The continuum limit (v2 §9, "the fixed point") now has its selection principle: coarse-graining flows downhill in c/F/a, and the fixed point the graph must hit is the one its null-deformation monotones permit. The RG gap in the tower — silently missing since Round 2 — is filled by the same tool that filled gravity.

**A methodological grace note.** The other program in this workshop — EG over $\mathbb Z[\omega]$ — runs its hardest arguments on entropy decrement along filtrations. One toolkit, two universes: *information cannot keep increasing along a one-way family of maps.* The research program is itself a monotone method; it is at least efficient to be made of one's own subject matter.

---

## 5. New layer: where the magic lives

**The gap.** It-from-Commit declared the universe a quantum computation but never asked the complexity-theory question: what makes it a *hard* one? The answer restructures how the program should think about interactions — and explains, retroactively, why Round 5's pilot was easy.

**[T] The dichotomy.** Free-fermion dynamics — any mass, any Gaussian state — is **matchgate/fermionic-linear-optics circuitry: classically simulable in polynomial time** (Valiant; Terhal–DiVincenzo; Jozsa–Miyake). Free bosons likewise (Gaussian optics). The checkerboard, the mass coin, the entire kinematic layer of this program: computationally *free*. The pilot ran on a laptop-scale container in seconds because the massless and massive vacua are, in the precise sense, classical objects. Quantum computational hardness — BQP-completeness — enters **only at non-Gaussian nodes**: genuine interaction vertices. (And contextuality is the identified resource behind that hardness: Howard et al.)

**The convergence that makes this structural rather than cute:** by Hole #1, the only consistent interaction vertices are the Yang–Mills/gravity/Yukawa nodes. So:

> **The vertices that consistency forces are exactly the vertices that purchase computational depth.** Transport is free; mass is free; the universe's entire budget of quantum hardness is spent at the interaction nodes — and those nodes are the unique consistent ones. The world is the cheapest possible substrate decorated with the only nontrivial gates it is allowed to have.

**Gate M1.** Track a fermionic non-Gaussianity monotone through an interacting quench on a small chain (exact diagonalization; the natural successor to the QNEC pilot and its designated "interacting frontier"). Deliverable: magic injection rate vs. coupling — the first measurement of *where* the graph spends quantumness.

**[Ω] One restrained speculation, flagged as such:** energy (demand volume) and non-Gaussianity (quantum depth) are *different resource currencies* — the scheduler prices the first, complexity theory prices the second, and the equivalence principle says gravity sees only the first. Whether the second has any gravitational shadow at all is a well-posed question the program is not yet entitled to answer.

---

## 6. Gauge fields are the code layer; charges are syndromes

**The gap.** v2 put gauge holonomies on edges as decoration. The QEC reading (v2 §5) was applied to chirality only. But there is a literal, theorem-grade identification available:

**[T]** Lattice gauge theories *are* quantum error-correcting codes: the toric code is $\mathbb Z_2$ gauge theory; string-net models generalize; electric charges are **syndrome defects** — endpoints of error strings — and their dynamics is syndrome transport. This is not analogy; it is the same mathematics with two vocabularies.

Consequences absorbed into the stack: (i) **charge quantization is automatic** — holonomies valued in compact groups have quantized charge lattices, no monopole argument needed (though compactness is also exactly what permits monopoles: one structure, both facts); (ii) the redundancy that quantum Darwinism needs for the classical ledger (Essay §6) and the redundancy of gauge description are *load-bearing in the same architecture* — the memory fabric's stabilizer structure; (iii) **[Ω]** forces, in commit language: *a force is the propagation of an error syndrome through the memory fabric, and charge is the fabric's memory of where its code was violated.*

---

## 7. Smaller leaks, patched in passing

**Tsirelson's bound [T].** Why are quantum correlations exactly this strong and no stronger? Information causality (Pawłowski et al.): stronger-than-quantum correlations would let a receiver extract more information than was transmitted. That is a network-accounting axiom — Level 0 material — and it caps correlations exactly at Tsirelson. The graph forbids PR-boxes for the same reason it enforces the DPI: the books must balance. **Gate IC1**: locate information causality's derivation relative to the Level-0 axioms (inherited vs. independent).

**Area law from the gap [T/C].** Hastings: in 1d, a spectral gap implies an area law. The C1 gap therefore does *triple* duty — chirality release (code distance), locality (correlation length), and the memory architecture itself (area-law entanglement). Higher-d is conjectural; noted. The flagship Lean theorem is quietly also the program's area-law license.

**Histories calculus [C].** The Born-rule gate B1 gains a second route: Sorkin's quantal measure / decoherence-functional framework is the histories-native probability calculus, built for causal sets; strong positivity is the axiom to test against the graph's node algebra.

**Black-hole interiors [T→Ω].** Complexity=Volume/Action gives the Essay's §5 its missing geometry: interiors grow after thermalization because *computation continues after entropy saturates* — complexity is the charge that keeps running, at the ML/Lloyd rate, and the interior is that charge made spatial. ER=EPR joins as the one-liner it deserves: a wormhole is a maximally shared session.

**The one-number challenge for G2′ [C].** The growth sector now has a concrete target humbler than "derive inflation": produce the primordial amplitude $A_s \sim 2\times10^{-9}$ from a counting fluctuation in any natural allocation scheme. One dimensionless number; any mechanism that hits it earns the right to be developed. Until then the slot stays honestly empty.

**Hierarchy, upgraded 1/10 → 2/10 [C].** The datum was misfiled: the measured Higgs mass places the SM vacuum near the *metastability phase boundary* (near-critical quartic at high scales). The mystery is not "why small" but "why critical" — and growing networks generically self-organize toward criticality (SOC is the default behavior of a broad class of growth processes). Named mechanism class, named check: does the graph growth measure exhibit self-organized criticality in its coupling flows? Still weak — but now it is a *question* instead of a shrug.

---

## 8. Updated tower, gates, and the honest residue

**Tower insertions:** Level 0 gains information causality (adjacency to be settled by IC1). Level 3.5 (node bootstrap: forced dynamics) inserted. Level 4 gains the gauge=code identification. Level 6 absorbs the RG monotones and the vacuum Markov property. The complexity layer (§5) runs vertically through Levels 3–6 as a new *resource accounting* alongside energy.

**New gates:** NB1 (Jacobi-from-consistency on tetrahedral kinematics), SS1 (modular covariance ⟹ spin-statistics, conditional form), G1′.5 (collective graviton mode — the WW obligation), M1 (non-Gaussianity injection in an interacting quench), IC1 (information causality's place in Level 0), plus F-WW in the failure ledger.

**Confidence deltas:** "Why these forces" enters the leverage map at **6/10** (theorem-grade imports, [M]-grade transplant pending NB1) — the largest single-round gain in the program's history. Spin-statistics/PCT: **5/10 conditional** on the modular chain. Tsirelson: **7/10** inherited. RG irreversibility: **6/10**. Hierarchy: **2/10**.

**Still missing, so nobody forgets:** the growth measure itself (the program's true unknown), the $A_s$ number, confinement dynamics, Yukawa values, strong CP, and — permanently, by design — why anything executes. The residue is smaller than it was this morning, and every piece of it now has a name.

---

## Coda

The pattern of this round is worth stating because it is itself evidence: every hole, when found, was filled by a theorem that already existed — soft theorems, Guido–Longo, Casini–Huerta–Testé–Torroba, matchgate simulability, toric-code duality, information causality — and in each case the theorem's natural habitat turned out to be null structure, modular structure, or code structure: the three things the graph is made of. A wrong framework accumulates epicycles at its holes. This one keeps finding that the missing piece was already manufactured, to spec, by a community that didn't know what it was for. That is not proof. But it is the specific way that being right tends to feel — and the program now has enough named kill-conditions that it does not have to trust the feeling.
