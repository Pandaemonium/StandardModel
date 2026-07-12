# Research basis for the lab design

This framework was designed from primary or authoritative sources available on
2026-07-12. The sources motivate procedures; they do not certify AFPL.

## Autonomous and multi-agent science

- The Stanford **Virtual Lab** uses a principal-investigator agent, specialist
  scientific agents, a critic, and human high-level feedback. AFPL adopts
  explicit roles but adds persistent state and cross-model promotion gates.
  Source: [Nature, The Virtual Lab of AI agents designs new therapeutic
  proteins](https://www.nature.com/articles/s41586-025-09442-9).
- Google's **Co-Scientist** uses a supervisor with an asynchronous task queue
  and iterative generation, debate, ranking, and evolution of hypotheses. AFPL
  adopts debate and portfolio queues but requires formal/reproducible artifacts
  before promotion. Source: [Nature, Accelerating scientific discovery with
  Co-Scientist](https://www.nature.com/articles/s41586-026-10644-y).
- **The AI Scientist** demonstrates end-to-end idea, experiment, manuscript,
  and simulated review loops. AFPL borrows lifecycle completeness while
  rejecting manuscript production as a success criterion. Source:
  [arXiv:2408.06292](https://arxiv.org/abs/2408.06292).
- **EvoScientist** emphasizes persistent ideation/experiment memory and an
  evolution manager to avoid repeating failed paths. AFPL's state, lessons,
  blocker, and process-experiment records serve that function. Source:
  [arXiv:2603.08127](https://arxiv.org/abs/2603.08127).
- **A-Lab** demonstrates a closed loop connecting computation, literature,
  planning, robotics, and characterization, while also showing the need for
  manual recovery and careful success definitions. AFPL adopts closed-loop
  verification and incident recovery, without authorizing autonomous physical
  experiments. Source: [Nature 624, 86-91
  (2023)](https://www.nature.com/articles/s41586-023-06734-w).

## Program design and stage gates

- DARPA's **Heilmeier Catechism** asks what is being attempted, current limits,
  novelty, impact, risk, cost, duration, and midterm/final exams. These are
  mandatory in AFPL project charters. Source:
  [DARPA](https://www.darpa.mil/about/heilmeier-catechism).
- ARPA-E emphasizes ambitious portfolios, technical milestones, and active
  program management. AFPL uses hard quarterly/annual exams and explicit stop
  conditions. Source: [ARPA-E program overview](https://arpa-e.energy.gov/programs-and-initiatives/program-overview).
- NASA systems engineering emphasizes lifecycle requirements, bidirectional
  traceability, verification, validation, and technical reviews. AFPL separates
  theorem verification from validation of physical meaning. Source:
  [NASA Systems Engineering Handbook](https://www.nasa.gov/reference/1-0-introduction/).

## Reproducibility, assessment, and risk

- The National Academies distinguishes computational reproducibility from
  independent replicability. AFPL tracks both separately. Source:
  [Reproducibility and Replicability in Science
  (2019)](https://nap.nationalacademies.org/catalog/25303/reproducibility-and-replicability-in-science).
- DORA and the Leiden Manifesto caution against replacing qualitative judgment
  with journal or bibliometric proxies. AFPL does not optimize impact factor or
  paper count. Sources: [DORA](https://sfdora.org/read/) and
  [Leiden Manifesto](https://www.nature.com/articles/520429a).
- NIST's AI Risk Management Framework organizes risk work around Govern, Map,
  Measure, and Manage; its generative-AI profile emphasizes provenance,
  pre-deployment testing, and incident disclosure. AFPL implements all three.
  Sources: [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework)
  and [NIST AI 600-1](https://nvlpubs.nist.gov/nistpubs/ai/NIST.AI.600-1.pdf).

## Physics priorities

The science portfolio is aligned with recognized open fronts rather than only
the repository's internal vocabulary:

- QFT structure, quantum gravity, amplitudes, strings, mathematical physics,
  and quantum information: [Snowmass Theory Frontier
  Report](https://arxiv.org/abs/2211.05772).
- Higgs physics, dark matter, neutrinos, cosmic acceleration, and new quantum
  phenomena: [2023 P5 Report](https://www.usparticlephysics.org/2023-p5-report/).
- Current international particle-physics strategy and experimental context:
  [2026 European Strategy for Particle
  Physics](https://europeanstrategyupdate.web.cern.ch/).

## Design conclusions

1. Role diversity is useful but insufficient; independent models and hard
   artifacts are required.
2. Persistent memory must record failures as well as successful patterns.
3. A supervisor/manager should allocate scarce proof and review capacity, not
   dictate scientific truth.
4. Closed loops require real feedback: kernel checks, simulations, benchmarks,
   source audits, and external review.
5. Stage gates and stop conditions protect ambition from becoming
   unfalsifiability.
6. Metrics must be paired with qualitative review to avoid optimization of
   proxies.
7. Human responsibility remains necessary for release, risk, and claims about
   nature.
