=== context around PlueckerRestOperatorGeneral citation ===
...l decomposition.  If
$M=[\psi\ \phi]$ has full rank and $M'=MR$ with $R\in U(2)$, then
$M'M'^\dagger=MM^\dagger$ and
$\det M'=(\det R)\det M$.  Since $|\det R|=1$, the two mass operators are
related by \eqref{eq:phasecov}.  The unitary-equivalence class of $B_z$ depends
only on $P$; an oriented factorization retains the phase needed by individual
turn amplitudes.  \Classical{} \Kernel{}

The distinction matters physically.  The spectrum is decomposition
independent, while an amplitude can remain sensitive to orientation.  The
construction preserves exactly the information needed by a path sum and
forgets exactly the information a rest energy cannot observe.

\subsection{One cubic closure: many constituents, and the interaction}
\label{sec:cubiclosure}

The two-spinor operator above is the visible corner of a single finite
algebra.  For \emph{any} number of spinors $\psi_i=(u_i,v_i)$, the
pairwise areas $z_{ij}=u_iv_j-u_jv_i$ assemble into the antisymmetric
matrix $Z=uv^{\mathsf T}-vu^{\mathsf T}$, and the complete area budget
is the Gram determinant, equal by an exact Lagrange identity to the
total pairwise area, $\mu^2=\sum_{i<j}|z_{ij}|^2$.  The kernel-checked
structure (\texttt{PlueckerRestOperatorGeneral}) is:
\begin{equation}\label{eq:cubiclosure}
  ZZ^\dagger Z=\mu^2 Z,
  \qquad
  B_w=\begin{pmatrix}0&Z\\ Z^\dagger&0\end{pmatrix},
  \qquad
  B_w^3=\mu^2 B_w,
\end{equation}
with $B_w$ odd Hermitian for the block grading, $B_w^2$ equal to
$\mu^2$ times a projector of trace exactly four for every $n$ with
$\mu^2\neq0$ --- the rest gap $\pm\mu$ always lives on a four-dimensional
support --- the two...

=== context around PlueckerRestOperatorGeneral citation ===
...env lean PhysicsSM/Draft/NullEdge/VariablePlueckerLocalWalk.lean
lake env lean PhysicsSM/Draft/NullEdge/VariablePlueckerPhaseConnection.lean
lake env lean PhysicsSM/Draft/NullEdge/ComplexPlueckerCheckerboardPathSum.lean
lake env lean PhysicsSM/Draft/NullEdge/GlobalPhaseWindingNoGo.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerWindingDerived.lean
lake env lean PhysicsSM/Draft/NullEdge/StrictQCAMinimalArchitecture.lean
lake env lean PhysicsSM/Draft/NullEdge/CommutatorWilsonStrictnessKill.lean
lake env lean PhysicsSM/Draft/NullEdge/TemporalBlockingRG.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochSplitPlus.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochSplitMinus.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean
lake env lean PhysicsSM/Draft/NullEdge/FiniteCARFockBasic.lean
lake env lean PhysicsSM/Draft/NullEdge/FiniteCARSecondQuantization.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerQuarticInteraction.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerCausalCone.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerLayerCone.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPairGenerator.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerRestOperatorGeneral.lean
lake env lean PhysicsSM/Draft/NullEdge/PairKickSelection.lean
lake env lean PhysicsSM/Draft/NullEdge/SplitStepChargeBalance.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseObservable.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseDefectSpectrum.lean
lake env lean PhysicsSM/Draft/NullEdge/ChangingLatticePDECore.lean
lake env lean PhysicsSM/Draft/NullEdge/Carrier/PluckerScal...

=== context around PlueckerRestOperatorGeneral citation ===
...the corollary above,
  any such stay-put route must quantify what replaces the involutory
  unit-speed tangent.  In $3+1$, remove the three
  proven even-parity origin
   aliases and both mass-independent body-center modes while retaining locality,
   unitarity, continuum isotropy, and the complex-mass rate, and eliminate
   the residual non-Dirac states that persist in the Gupta--Short family.
   The corrected search should separate a globally chirality-preserving control
   class from an escape class with a nonzero $\Xi$-odd term whose constant and
   linear jets vanish; exact group-commutator loops are the first such candidate.
   Equations
   \eqref{eq:cornerparity} and \eqref{eq:bodycentermodes} are the regression
   tests.
  \item \textbf{Complete the tetrahedral comparison.}
  Compute the tetrahedral walk's full Bloch symbol in a common blocked unit
  cell and audit its corners, bands, and locality radius.  Constant onsite
  equivalence is already constrained by the alias-preservation no-go; a
  genuine comparison must specify any blocking or coarse-graining map.
  \item \textbf{Generalize the Pluecker rest operator.}
  Now largely resolved in kernel-checked form
  (\texttt{PlueckerRestOperatorGeneral}): for \emph{any} number of
  spinors, the pairwise-area matrix $Z$ obeys the exact cube closure
  $ZZ^\dagger Z=\mu^2 Z$ with $\mu^2$ the complete area budget (Gram
  determinant; Lagrange identity $\sum_{i<j}|z_{ij}|^2=\mu^2$), the odd
  Hermitian block operator obeys $B_w^3=\mu^2 B_w$ --- the same finite
  closure law as the interaction generator's $K^3=|z|^2K$ --- with
  $B_w^2$ equal to $\mu...

=== context around PairKickSelection citation ===
...v lean PhysicsSM/Draft/NullEdge/VariablePlueckerPhaseConnection.lean
lake env lean PhysicsSM/Draft/NullEdge/ComplexPlueckerCheckerboardPathSum.lean
lake env lean PhysicsSM/Draft/NullEdge/GlobalPhaseWindingNoGo.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerWindingDerived.lean
lake env lean PhysicsSM/Draft/NullEdge/StrictQCAMinimalArchitecture.lean
lake env lean PhysicsSM/Draft/NullEdge/CommutatorWilsonStrictnessKill.lean
lake env lean PhysicsSM/Draft/NullEdge/TemporalBlockingRG.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochSplitPlus.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochSplitMinus.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean
lake env lean PhysicsSM/Draft/NullEdge/FiniteCARFockBasic.lean
lake env lean PhysicsSM/Draft/NullEdge/FiniteCARSecondQuantization.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerQuarticInteraction.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerCausalCone.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerLayerCone.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPairGenerator.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerRestOperatorGeneral.lean
lake env lean PhysicsSM/Draft/NullEdge/PairKickSelection.lean
lake env lean PhysicsSM/Draft/NullEdge/SplitStepChargeBalance.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseObservable.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseDefectSpectrum.lean
lake env lean PhysicsSM/Draft/NullEdge/ChangingLatticePDECore.lean
lake env lean PhysicsSM/Draft/NullEdge/Carrier/PluckerScaleSelectionNoGo.lean
lake build PhysicsSM.Draft.NullEdge.Overni...

=== context around PairKickSelection citation ===
...aw and the quartic dynamics from one
  field-valued action whose reductions also produce the null-spinor geometry
  and one-particle evolution.
  A sharper pre-registered step (conjecture, with gate and kill
  condition): among Hermitian even quartic CAR polynomials supported on
  one pair block, characterize the exact solution space of the
  phase-covariance constraint --- the requirement that the gate family
  transform under the walk's exact common-phase removal with forward
  amplitude transforming as the derived datum $z$.  We conjecture the
  solution space is exactly the real span of the displayed
  conjugate-oriented generator and its quarter-phase rotation (real
  dimension two), so the supplied interaction is the unique
  phase-reading quartic up to its own circle parameter.  The gate is
  finite rational linear algebra on the coefficient space.  The kill
  condition is a solution dimension above two; in that case the surplus
  generators are themselves the result --- interactions the transported
  phase cannot distinguish --- and the uniqueness reading is withdrawn.
  The gate computation has since been executed and the conjecture is
  RESOLVED, machine-checked (\texttt{PairKickSelection}, kernel-only):
  equivariance under the
  site-local chiral phase, Hermiticity for every field value, and
  vanishing at zero field force the coefficient matrices to the single
  complex parameter $H(z)=\begin{psmallmatrix}0&\alpha z\\
  \overline{\alpha z}&0\end{psmallmatrix}$ --- the solution space is
  exactly the conjectured two-real-dimensional family (uniqueness), every
  member satisfies ...

=== context around SplitStepChargeBalance citation ===
...r step is a non-scalar involution for all
$\theta$.  It therefore retains exact quasienergies $0$ and $\pi$ even after
the mass coin is turned on: the present cubic regulator admits no uniform
Floquet gap (a body-center crossing at $0$ and $\pi$ persists for every
mass angle).
The closed body-center matrix, involution identity, and both explicit
eigenmodes are \NoGo{} \Kernel{}.

The interior crossings moreover carry an exact charge bookkeeping.  At
each of the eight nodes $q_j\in\{\pi/2,3\pi/2\}$ the massive step has
two-dimensional $+1$ and $-1$ eigenspaces simultaneously, and the
Schur-reduced crossing Jacobian of every node and gap is one of exactly
two diagonal matrices, $\pm\tfrac45\,\mathrm{diag}(-1,1,-1)$, with
determinant $\pm(\cos\theta)^3$ at the $3$-$4$-$5$ angle --- every node
is a nondegenerate cone.  The resulting local charges (the Jacobian
determinant signs) are distributed by the parity of the node's
$3\pi/2$-coordinates, are opposite at the two quasienergies of each
node (the Floquet pairing), and sum to zero at each quasienergy
separately.  The two Jacobian charges, the per-node Floquet
opposition, and the eight-node sum-zero census are machine-checked
(\texttt{SplitStepChargeBalance}, kernel-only); the Schur reduction
from the walk symbol to the displayed Jacobians is the exact
run-record layer.  The doublers of this walk are
not merely present: they are exactly the charge partners the sum rule
demands, and the two gaps compensate node by node.

The obstruction is also visible in an exact all-zone criterion.  Write
$x=\cos q_x$, $y=\cos q_y$, $w=\cos q_z$, and $c=\cos\theta$...

=== context around SplitStepChargeBalance citation ===
...n.lean
lake env lean PhysicsSM/Draft/NullEdge/ComplexPlueckerCheckerboardPathSum.lean
lake env lean PhysicsSM/Draft/NullEdge/GlobalPhaseWindingNoGo.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerWindingDerived.lean
lake env lean PhysicsSM/Draft/NullEdge/StrictQCAMinimalArchitecture.lean
lake env lean PhysicsSM/Draft/NullEdge/CommutatorWilsonStrictnessKill.lean
lake env lean PhysicsSM/Draft/NullEdge/TemporalBlockingRG.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochSplitPlus.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochSplitMinus.lean
lake env lean PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean
lake env lean PhysicsSM/Draft/NullEdge/FiniteCARFockBasic.lean
lake env lean PhysicsSM/Draft/NullEdge/FiniteCARSecondQuantization.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerQuarticInteraction.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerCausalCone.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerLayerCone.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPairGenerator.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerRestOperatorGeneral.lean
lake env lean PhysicsSM/Draft/NullEdge/PairKickSelection.lean
lake env lean PhysicsSM/Draft/NullEdge/SplitStepChargeBalance.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseObservable.lean
lake env lean PhysicsSM/Draft/NullEdge/PlueckerPhaseDefectSpectrum.lean
lake env lean PhysicsSM/Draft/NullEdge/ChangingLatticePDECore.lean
lake env lean PhysicsSM/Draft/NullEdge/Carrier/PluckerScaleSelectionNoGo.lean
lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard
python Scripts/sim/null_edge_regulator_benchmar...
