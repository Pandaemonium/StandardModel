# Aristotle semantic context pack

Generated: 2026-07-21T06:22:47
Query: `uniformly gapped moving spectral projector finite-step leakage vanishing slow schedule adiabatic low-energy band`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Interpretation and open problems]

Score: `0.757`

```text
ompact-support momentum-space $L^2$ limit are closed.  Control
  the changing lattice/continuum Fourier spaces and identify the limiting
  multiplier with the position-space Dirac PDE propagator.  The abstract
  bulk/tail split and vanishing of the ultraviolet tail under measurable
  monotone band exhaustion are now closed for arbitrary $L^2$ data, and the
  per-step symbol estimate now carries the refined form
  $2B_4^2t^2/n\cdot\exp(|t|B_4/n)$, which retains the small-step factor
  that the earlier bound discarded; the remaining frontier is the
  balancing of a growing momentum window against the Sobolev tail,
  composed with the concrete scaled sampling/interpolation isometry.
  Equations \eqref{eq:plancherel3}, \eqref{eq:countablel2},
  \eqref{eq:continuousl2multiplier}, and \eqref{eq:walkcompactl2} close the
  finite, abstract countable, and compact-support multiplier steps, not that
  final physical identification.
  \item \textbf{Remove the lattice partners without losing the derivation.}
  The no-go \eqref{eq:stationarynogo} rules out the naive degree-one
  stationary-amplitude factor with a full Dirac tangent.  The Wilson
  construction \eqref{eq:wilsonsquare} now removes the unwanted corners and
  gives a uniform massive gap for a nearest-neighbor Hamiltonian.  The open
  task is to retain that spectral success in a strictly finite-range,
  exactly unitary discrete-time update.  Test the enlarged
  internal cells, longer Laurent range, and tilted-projector stay-put
  constructions of the kind realized by Gupta and Short
  \cite{GuptaShortDoubling} while preserving the
  Pluecker-derived coin and exact path dictionary; by the corollary above,
  any such stay-put route must quantify what replaces the involutory
  unit-speed tangent.  In $3+1$, remove the three
```

### 2. `AgentTasks/overnight-publication-run-2026-07-11/GRAND_STRATEGY5_REVIEW_2026-07-11.md` [5. Single best Paper D theorem after finite spectral conjugacy, and shortest]

Score: `0.750`

```text
## 5. Single best Paper D theorem after finite spectral conjugacy, and shortest
path to an operational consequence

**Best theorem: `fourier_localStep_iterate`** (all finite time steps are exactly
powers of the pointwise finite character block at every momentum), backed by
`localStep_eq_inverseFourier_symbol`. It is the exact, all-zone spectral
diagonalization of the dynamics — not a sampled-momentum substitute (it is
universally quantified over `k : Position L`), so it clears reject-list item (c).

**Shortest path to an operational consequence (three steps, all in-scope):**
1. `finiteLocalSymbol_unitary` (present) ⇒ each block preserves the internal
   inner product at every `k`.
2. Combine with `fourier_parseval` (present) ⇒ **exact ℓ² norm conservation of
   the full iterate**: `positionNormSq (localStep^[n] ψ) = positionNormSq ψ`.
   This is Job 2 and is the first genuinely operational statement.
3. From norm conservation + linearity, derive a **two-symbol state-distance /
   Trotter-type bound**: `‖localStep_{m,eps}^[n] ψ − localStep_{m',eps'}^[n] ψ‖`
   controlled by the momentum-wise block difference `‖A_k^n − B_k^n‖`. That is
   the operational distance confronting arXiv:1212.2839 the gate matrix wants.

**Blocker:** step 3's continuum/position-space rate still needs the *missing*
physical scaling + Shannon interpolation; do NOT present the ℓ² isometry or the
coefficient-tail rate as continuum `R^3` convergence (reject-list (c)). **Honest
fallback:** ship steps 1–2 (exact finite unitary dynamics + norm conservation)
as the operational core and keep the continuum rate preregistered.

---
```

### 3. `AgentTasks/aristotle-downloads/da29672d-telescope-extract/output-final_aristotle/AgentTasks/afpl-hnu-realspace-aristotle-2026-07-13.md` [Objective]

Score: `0.747`

```text
## Objective

Starting from the supplied exact HNU momentum-space core, construct the finite
periodic real-space schedule whose Fourier symbol is exactly each
projector-conditioned substep and hence the depth-eight endpoint.  This is the
missing bridge from a noncommutative topological symbol to an actual local
microscopic update.
```

### 4. `AgentTasks/aristotle-downloads/da29672d-gate1-extract/output-final_aristotle/AgentTasks/afpl-hnu-realspace-aristotle-2026-07-13.md` [Objective]

Score: `0.747`

```text
## Objective

Starting from the supplied exact HNU momentum-space core, construct the finite
periodic real-space schedule whose Fourier symbol is exactly each
projector-conditioned substep and hence the depth-eight endpoint.  This is the
missing bridge from a noncommutative topological symbol to an actual local
microscopic update.
```

### 5. `AgentTasks/afpl-hnu-realspace-aristotle-2026-07-13.md` [Objective]

Score: `0.747`

```text
## Objective

Starting from the supplied exact HNU momentum-space core, construct the finite
periodic real-space schedule whose Fourier symbol is exactly each
projector-conditioned substep and hence the depth-eight endpoint.  This is the
missing bridge from a noncommutative topological symbol to an actual local
microscopic update.
```

### 6. `Sources/Null_Edge_Obstruction_Letter_Draft_2026-07-11.tex` [Which repairs are impossible: two no-go theorems and a corollary]

Score: `0.744`

```text
one-step, unitary at every
momentum, normalized at the origin, with stationary block
$\gamma_0=\id-\gamma_+-\gamma_-\neq0$ built from tilted velocity projectors
(their Eqs.~(29)--(30), (37)).  Its tangent generator, though automatically
Hermitian, therefore cannot be an involution ($M^2\neq\id$): stay-put
freedom is purchased exactly by relinquishing the involutory unit-speed
Dirac tangent.  Their $3+1$ family moreover retains extraneous Weyl-like
low-energy solutions at isolated momenta $\pm\mathbf q(\theta)$ (their
Appendix~F), so a strictly local, exactly unitary, fully alias-free $3+1$
walk with the complete involutory Dirac tangent remains open in both
programs.
\end{corollary}

The three results triangulate the design space: inside the minimal
architecture the aliases are unavoidable (Theorem~\ref{thm:allcoins}); a
stay-put escape is incompatible with the exact unit-speed tangent
(Theorem~\ref{thm:stationary}, Corollary~\ref{cor:gs}); and the massive
spectrum of the minimal walk fails to gap at exactly classified points
(Theorems \ref{thm:det}--\ref{thm:bodycenter}).  A Wilson-type Hamiltonian
comparison removes the non-origin corners and opens a uniform massive gap
\emph{at the Hamiltonian level only}; its finite-time exponential is not a
strictly finite-range one-step update, and we do not conflate the two.
```

### 7. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Uniform many-step Dirac control]

Score: `0.739`

```text
\section{Uniform many-step Dirac control}
\label{sec:continuum}

The finite walk should approximate the continuous Dirac flow over a fixed
macroscopic time, not merely at one infinitesimal step.  For the real
representative of the phase-conjugacy class, write
\begin{equation}
 U(q,r)=e^{-\ii q\sigma_z}e^{-\ii r\sigma_x},
 \qquad
 H(k,\mu)=k\sigma_z+\mu\sigma_x,
 \qquad
 V_t(k,\mu)=e^{-\ii tH(k,\mu)}.
\end{equation}

\begin{theorem}[Uniform bounded-momentum product limit]\label{thm:rate}
For $K,M\geq0$, define
\begin{align}
 C_{\mathrm{box}}(K,M)
   &=2K^2+2M^2+KM^2+K^2M+KM,\\
 D_{\mathrm{box}}(K,M)
   &=4C_{\mathrm{box}}(K,M)
     +4(K+M)^2e^{K+M}.
\end{align}
If $|k|\leq K$, $|\mu|\leq M$, $n>0$, and $|t/n|\leq1$, then
\begin{equation}\label{eq:rate}
 \norm{
   U\!\left(k\frac{t}{n},\mu\frac{t}{n}\right)^n
   -V_t(k,\mu)}
 \leq D_{\mathrm{box}}(K,M)\frac{t^2}{n}.
\end{equation}
The bound is uniform on the displayed parameter box, and its right-hand side
tends to zero as $n\to\infty$.
\end{theorem}
\noindent\NewResult{} \Kernel{}

\begin{proof}[Proof architecture]
The one-step walk differs from $\id-\ii(t/n)H$ by an explicit quadratic
remainder.  The exact exponential differs from the same first-order matrix by
another quadratic remainder, giving
$\norm{U-V_{t/n}}\leq D(k,\mu)t^2/n^2$.  Both matrices are unitary, so the power
telescope has no norm-growth factor:
\[
 \norm{U^n-V_{t/n}^n}\leq n\norm{U-V_{t/n}}.
\]
The exact short-time flows compose to $V_t$, producing the $1/n$ rate.  Finally
$D(k,\mu)\leq D_{\mathrm{box}}(K,M)$ on the parameter box.  Lean checks the
entrywise remainder estimates, operator-norm conversion, unitarity, telescope,
flow composition, box inequality, and limit.
\end{proof}

\begin{figure}[t]
\centering
\includegraphics[width=0.88\linewidth]{nul
```

### 8. `AgentTasks/model-calls/claude/2026-06-24-round-009-adversarial-next-job.md` [Candidate B: unitary evolution U_s = exp(−isH), spectral decomposition]

Score: `0.738`

```text
## Candidate B: unitary evolution U_s = exp(−isH), spectral decomposition
```

## Scoped paper hits

### 1. Dirac equation with an ultraviolet cutoff and a quantum walk

Score: `0.722`
Zotero key: `G7NXEZBU`
DOI: `10.1103/physreva.81.012314`

### 2. The Spectral Action Principle

Score: `0.707`
Zotero key: `6WURA7MF`
DOI: `10.1007/s002200050126`
URL: https://doi.org/10.1007/s002200050126

### 3. The Dirac equation as a quantum walk: higher dimensions, observational convergence

Score: `0.700`
Zotero key: `4F87TGCN`
arXiv: `1307.3524`
DOI: `10.1088/1751-8113/47/46/465302`

### 4. Relativistic effects and rigorous limits for discrete- and continuous-time quantum walks

Score: `0.695`
Zotero key: `QSB24VR9`
DOI: `10.1063/1.2759837`
URL: https://doi.org/10.1063/1.2759837

### 5. Locality properties of Neuberger's lattice Dirac operator

Score: `0.690`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 6. Dirac quantum walk on tetrahedra

Score: `0.685`
Zotero key: `8RZQA73D`
arXiv: `2404.09840`
DOI: `10.1103/physreva.110.042418`
URL: http://arxiv.org/abs/2404.09840
