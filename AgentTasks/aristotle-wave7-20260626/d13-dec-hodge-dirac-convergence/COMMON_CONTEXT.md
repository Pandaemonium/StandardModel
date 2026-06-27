# Common null-edge context for Aristotle Wave 7

This is a no-build strategy/audit wave for the null-edge/null-strand mass and super-Dirac program.

Core guardrails:

- Use the safe thesis: mass is quadratic obstruction by a canonical obstruction map B.
- Do not claim all mass is Plucker spread. P1 is a finite kinematic Plucker theorem: massless iff collinear.
- Avoid double counting: Plucker/null spread is kinetic-side invariant; Phi_H^2 is the internal zero-order block; on shell K_null = Phi_H^2, not m_Plucker^2 + m_Higgs^2.
- Fermion masses live in Phi_H^2; W/Z masses live in |nabla^A H|^2, link stiffness, or Higgs-orbit obstruction.
- Do not say local gauge symmetry literally breaks. Use covariant internal reference section language, stabilizer directions remain gapless, and non-stabilizer holonomies acquire quadratic cost.
- QCD supplies confinement and dynamics; Plucker supplies invariant accounting.
- Prediction language requires rank(dF) < dim M_EFT or a nontrivial relation R(theta_EFT)=0.

Current gate map:

- Gate A: conventions, signs, gradings, and finite sign algebra.
- Gate B: finite dual-soldered algebra and P1/P1.5 theorem spine.
- Gate C: flat branch count, determinant/propagator-zero classification, species/doublers, Krein, and chirality.
- Gate D: continuum symbol, square limit, curvature, scalar/gauge kinetics, causal support.
- Gate E: electroweak physical interpretation, FMS/gauge-invariant composites, gauge language.
- Gate F: prediction/codimension/moduli-rank gate.
- Gate H: internal-spectrum, anomaly, Furey bridge, legal Yukawa blocks.

Recent literature leads to use:

Gate D:
- Dabetic-Hiptmair 2025/2026, arXiv:2507.19405, convergence of DEC for the Hodge-Dirac operator.
- Ramanan 2006, arXiv:math/0609464, discrete connection Laplacians.
- Singer-Wu 2013, arXiv:1306.1587, spectral convergence of connection Laplacians from random samples.
- Boguna-Krioukov 2025, arXiv:2506.18745, local causal-set d'Alembertian and warnings about nonlocal causal-set d'Alembertian convergence.

Gate C:
- Yumoto-Misumi 2021/2022, arXiv:2112.13501, lattice fermions as spectral graphs.
- Basak-Chakrabarti-Kishore 2025, arXiv:2501.10336, eigenspectra of minimally doubled fermions and modified/flavored chirality diagnostics.
- Catterall 2023/2024, arXiv:2311.02487, reduced Kahler-Dirac fermions and mirror/chiral issues.
- Existing Gate C source pack also includes Misumi 2025 arXiv:2512.22609, Golterman-Shamir 2025 arXiv:2505.20436, Weber 2023 arXiv:2312.08526, Weber 2025 arXiv:2502.16500, Capitani-Weber-Wittig 2009 arXiv:0910.2597.

Gate E/F:
- van Suijlekom et al. 2024, arXiv:2401.03705, Bratteli networks and spectral action on quivers.
- Maas 2023, arXiv:2305.01960, FMS mechanism review.
- arXiv:2603.12882, weak and Higgs physics from the lattice.

Gate H / super-Dirac:
- Furey 2025, arXiv:2505.07923, current division-algebra/internal-spectrum comparison.
- Cacic 2009, arXiv:0902.2068, moduli spaces of Dirac operators for finite spectral triples.
- Bochniak-Sitarz 2018, arXiv:1804.09482, finite pseudo-Riemannian spectral triples and the Standard Model.
- Ackermann-Tolksdorf 1995, arXiv:hep-th/9503153, generalized Lichnerowicz formulas.
- Tolksdorf 1996, arXiv:hep-th/9612149, Dirac-Yukawa operator and Einstein-Hilbert-Yang-Mills-Higgs action.

Desired response style:

- Be direct about no-go risks and hidden assumptions.
- Prefer theorem chains, precise definitions, acceptance/failure criteria, and Lean staging plans.
- Identify what can be proved finitely now, what is analytic/continuum, and what is only manuscript interpretation.
- Do not weaken claims silently. If the proposed route fails, say so and propose the safest downgrade.
