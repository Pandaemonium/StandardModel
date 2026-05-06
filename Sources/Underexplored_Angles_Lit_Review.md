# Literature Review: Underexplored Angles for PhysicsSM and COG

Based on the project's exploration of octonions, Fano/XOR sign conventions, $E_8$, Hamming codes, anomaly cancellation, lattice fermions, path integrals, Lean formalization, and the COG (Causal Octonionic Graph) state-machine idea, the following are the most promising underexplored theoretical angles.

## 1. Spectral Triples / Noncommutative Geometry as a "Known-Good Target"
This is arguably the strongest "adjacent established framework" for the project. Connes–Chamseddine-style noncommutative geometry derives the Standard Model action plus gravity from algebraic/spectral data, including finite internal geometry. The spectral action principle is explicitly designed to turn algebraic data $(\mathcal{A}, \mathcal{H}, D)$ into physics.

* **Why it matters:** The COG model currently features algebraic states and causal update rules. Spectral triples provide a disciplined way to ask: "What is the Dirac operator of my discrete algebraic graph?" Defining a finite/discrete spectral triple for COG establishes a bridge to Lagrangians, particle content, and geometry.
* **Concrete experiment:** Build a toy COG spectral triple: finite algebra of node states, Hilbert space of graph-local states, and a graph Dirac operator. Then test whether its automorphism/unitary structure recovers any $U(1)$-, $SU(2)$-, or $SU(3)$-like pieces.
* **Reference:** [The Spectral Action Principle (hep-th/9606001)](https://arxiv.org/abs/hep-th/9606001)

## 2. Exceptional Jordan Algebra / Freudenthal Systems
While octonions and $E_8$ are foundational, the **exceptional Jordan algebra** $J_3(\mathbb{O})$, primitive idempotents, $F_4$, $E_6$, $E_7$, and Freudenthal triple systems offer a robust physical mapping. Todorov and Drenska argue that an intersection inside $F_4$ coincides with the Standard Model gauge group $S(U(2) \times U(3))$. Boyle notes relationships between the complexified exceptional Jordan algebra, the Standard Model, left-right extensions, and $Spin(10)$.

* **Why it matters:** PhysicsSM uses octonion basis units as state labels, but particles may be more naturally represented as *idempotents, ideals, projectors, or rank-one observables* than as raw octonion units. This aligns well with the "vacuum idempotent" minimal-left-ideal direction.
* **Concrete experiment:** Re-express existing Furey-style minimal-left-ideal states in Jordan-algebra language: vacuum as an idempotent, fermion states as primitive idempotent/ideal data, and gauge transformations as stabilizers.
* **Reference:** [Octonions, exceptional Jordan algebra and the role of the group F_4 in particle physics (arXiv:1805.06739)](https://arxiv.org/abs/1805.06739)

## 3. Quantum Cellular Automata (QCA) / Quantum Walks as the Dynamics Layer
The COG idea needs a local tick rule. Quantum cellular automata and discrete-time quantum walks are close cousins: local, discrete-space/discrete-time update rules that can approximate relativistic particles. Recent work directly studies fermion doubling in QCA/quantum-walk models and how it relates to Nielsen–Ninomiya-style constraints.

* **Why it matters:** This provides an existing mathematical language for "Planck-tick local evolution" without immediately reinventing all of lattice QFT. It also highlights known traps: locality, unitarity, Lorentz recovery, and fermion doubling.
* **Concrete experiment:** Implement a tiny QCA-like COG rule for a 1D or 2D Dirac particle, then ask whether adding octonionic internal state labels naturally creates generations, doublers, or gauge-like phases.
* **Reference:** [Fermion Doubling in Quantum Cellular Automaton Models (arXiv:2505.07900)](https://arxiv.org/abs/2505.07900)

## 4. Anomaly Cancellation as a Diophantine/Code Constraint
Beyond treating anomaly cancellation purely as a physics requirement, the next step is to treat it as a **constraint-solving problem over charges**. Recent work frames anomaly equations as Diophantine equations and uses geometric methods such as the method of chords to generate solutions.

* **Why it matters:** This could become a rigorous "checksum" for any candidate particle spectrum produced by COG. Anomaly cancellation is fundamentally a structured arithmetic constraint on allowed charge assignments, akin to a lattice or code condition.
* **Concrete experiment:** Write a small solver that takes candidate COG particle states and computes all local gauge and mixed gravitational anomaly sums. Then make "anomaly-free" a first-class acceptance test.
* **Reference:** [Solving Gauge Anomaly Equations in the Standard Model (arXiv:2111.04148)](https://arxiv.org/pdf/2111.04148)

## 5. Higher Gauge Theory / 2-Groups for "Gauge Edges"
Thinking of edges as gauge operations might require higher gauge theory. Ordinary gauge theory may be too flat a language for a graph model with directed edges, compositional updates, nonassociativity, and higher-order relations among paths. Higher gauge theory generalizes ordinary gauge connections to higher categorical structures such as 2-groups and higher bundles.

* **Why it matters:** Octonion nonassociativity naturally suggests that "there is information not only on edges, but on triangles/path-compositions." Higher gauge theory is built to organize exactly this kind of data.
* **Concrete experiment:** Define COG data at three levels: node states, edge operations, and face/associator defects. Test whether octonion associators behave like curvature or a higher gauge field.
* **Reference:** [Higher Gauge Theory (arXiv:2401.05275)](https://arxiv.org/abs/2401.05275)

## 6. Causal Set Theory as a Stress Test
While COG is not strictly causal set theory, it overlaps strongly by treating discrete causal structure as fundamental. Causal set theory treats spacetime as a locally finite order relation. A central problem is that most causal sets are not manifold-like unless dynamics suppresses the non-manifold ones.

* **Why it matters:** "Having a causal graph" is not enough. A mechanism is needed that selects graph histories that look approximately like low-dimensional Lorentzian spacetime.
* **Concrete experiment:** Add manifold-likeness diagnostics to COG simulations: dimension estimators, light-cone growth rates, interval-size distributions, and recurrence structure. Reject rules that generate generic graph junk.
* **Reference:** [Dynamics of Causal Sets (gr-qc/0212064)](https://arxiv.org/abs/gr-qc/0212064)

## 7. Tensor Networks / Quantum Error-Correcting Codes for Emergent Locality
Holographic tensor-network models use quantum error-correcting codes to encode bulk degrees of freedom into boundary degrees of freedom, with perfect tensors/isometries as building blocks.

* **Why it matters:** If COG has deep graph-level microstates but observers see coarse local physics, then error-correcting-code structure may explain why macroscopic fields are stable against microscopic details.
* **Concrete experiment:** Ask whether the octonionic graph update preserves a protected subspace. Look for "logical states" that survive many microstate rewrites, analogous to encoded qubits in a stabilizer code.
* **Reference:** [Holographic quantum error-correcting codes (arXiv:1503.06237)](https://arxiv.org/abs/1503.06237)

## 8. ZX-Calculus / Categorical Quantum Mechanics as a Diagrammatic Rewrite Language
ZX-calculus is a graphical calculus for reasoning about quantum circuits and states, functioning as a formal rewrite-rule system.

* **Why it matters:** The COG model naturally fits a graphical rewrite system: local patches, update rules, associator defects, gauge edges, birth/death/split/merge operations. ZX-style diagrammatics could inspire a clean proof language.
* **Concrete experiment:** Define a mini "COG calculus" with generators and rewrite rules. Then formalize confluence/termination/local invariants in Lean before trying to claim physics.
* **Reference:** [ZX-calculus for the working quantum computer scientist (arXiv:2012.13966)](https://arxiv.org/pdf/2012.13966)

---

## Strategic Prioritization

To maximize payoff and build a rigorous pipeline:
1. **Spectral triples / noncommutative geometry**: Best bridge from algebraic data to Standard Model + gravity language.
2. **Exceptional Jordan/Freudenthal structures**: Best continuation of the octonion/$E_8$/idempotent direction.
3. **QCA/quantum-walk dynamics**: Best way to make COG's tick rules mathematically comparable to existing discrete relativistic models.

**Pipeline Approach:** Instead of jumping straight from algebra to the Standard Model, construct:
`Candidate algebraic state system` $\rightarrow$ `Local discrete dynamics` $\to$ `Anomaly checks` $\to$ `Continuum/low-energy diagnostics` $\to$ `Comparison with known NCG/Jordan/QCA structures`.
