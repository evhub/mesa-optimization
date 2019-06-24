_This is the fifth of five posts in the [Risks from Learned Optimization Sequence](https://www.alignmentforum.org/s/r9tYkB2a8Fp4DN8yB) based on the MIRI paper “[Risks from Learned Optimization in Advanced Machine Learning Systems](https://arxiv.org/abs/1906.01820)” by Evan Hubinger, Chris van Merwijk, Vladimir Mikulik, Joar Skalse, and Scott Garrabrant. Each post in the sequence corresponds to a different section of the paper._

&nbsp;

## Related work

**Meta-learning.** As described in [the first post](https://www.alignmentforum.org/s/r9tYkB2a8Fp4DN8yB/p/FkgsxrGf3QxhfLWHG), meta-learning can often be thought of meta-optimization when the meta-optimizer's objective is explicitly designed to accomplish some base objective. However, it is also possible to do meta-learning by attempting to make use of mesa-optimization instead. For example, in Wang et al.'s “Learning to Reinforcement Learn,” the authors claim to have produced a neural network that implements its own optimization procedure.[(28)](https://intelligence.org/learned-optimization#bibliography) Specifically, the authors argue that the ability of their network to solve extremely varied environments without explicit retraining for each one means that their network must be implementing its own internal learning procedure. Another example is Duan et al.'s “$RL^2$: Fast Reinforcement Learning via Slow Reinforcement Learning,” in which the authors train a reinforcement learning algorithm which they claim is itself doing reinforcement learning.[(5)](https://intelligence.org/learned-optimization#bibliography) This sort of meta-learning research seems the closest to producing mesa-optimizers of any existing machine learning research.

**Robustness.** A system is robust to distributional shift if it continues to perform well on the objective function for which it was optimized even when off the training environment.[(29)](https://intelligence.org/learned-optimization#bibliography) In the context of mesa-optimization, pseudo-alignment is a particular way in which a learned system can fail to be robust to distributional shift: in a new environment, a pseudo-aligned mesa-optimizer might still competently optimize for the mesa-objective but fail to be robust due to the difference between the base and mesa- objectives.

The particular type of robustness problem that mesa-optimization falls into is the reward-result gap, the gap between the reward for which the system was trained (the base objective) and the reward that can be reconstructed from it using inverse reinforcement learning (the behavioral objective).[(8)](https://intelligence.org/learned-optimization#bibliography) In the context of mesa-optimization, pseudo-alignment leads to a reward-result gap because the system's behavior outside the training environment is determined by its mesa-objective, which in the case of pseudo-alignment is not aligned with the base objective.

It should be noted, however, that while inner alignment is a robustness problem, the occurrence of unintended mesa-optimization is not. If the base optimizer's objective is not a perfect measure of the human's goals, then preventing mesa-optimizers from arising at all might be the preferred outcome. In such a case, it might be desirable to create a system that is strongly optimized for the base objective within some limited domain without that system engaging in open-ended optimization in new environments.[(11)](https://intelligence.org/learned-optimization#bibliography) One possible way to accomplish this might be to use strong optimization at the level of the base optimizer during training to prevent strong optimization at the level of the mesa-optimizer.[(11)](https://intelligence.org/learned-optimization#bibliography)

**Unidentifiability and goal ambiguity.** As we noted in [the third post](https://www.alignmentforum.org/s/r9tYkB2a8Fp4DN8yB/p/pL56xPoniLvtMDQ4J), the problem of unidentifiability of objective functions in mesa-optimization is similar to the problem of unidentifiability in reward learning, the key issue being that it can be difficult to determine the “correct” objective function given only a sample of that objective's output on some training data.[(20)](https://intelligence.org/learned-optimization#bibliography) We hypothesize that if the problem of unidentifiability can be resolved in the context of mesa-optimization, it will likely (at least to some extent) be through solutions that are similar to those of the unidentifiability problem in reward learning. An example of research that may be applicable to mesa-optimization in this way is Amin and Singh's[(20)](https://intelligence.org/learned-optimization#bibliography) proposal for alleviating empirical unidentifiability in inverse reinforcement learning by adaptively sampling from a range of environments.

Furthermore, it has been noted in the inverse reinforcement learning literature that the reward function of an agent generally cannot be uniquely deduced from its behavior.[(30)](https://intelligence.org/learned-optimization#bibliography) In this context, the inner alignment problem can be seen as an extension of the value learning problem. In the value learning problem, the problem is to have enough information about an agent's behavior to infer its utility function, whereas in the inner alignment problem, the problem is to test the learned algorithm's behavior enough to ensure that it has a certain objective function.

**Interpretability.** The field of interpretability attempts to develop methods for making deep learning models more interpretable by humans. In the context of mesa-optimization, it would be beneficial to have a method for determining whether a system is performing some kind of optimization, what it is optimizing for, and/or what information it takes into account in that optimization. This would help us understand when a system might exhibit unintended behavior, as well as help us construct learning algorithms that create selection pressure against the development of potentially dangerous learned algorithms.

**Verification.** The field of verification in machine learning attempts to develop algorithms that formally verify whether systems satisfy certain properties. In the context of mesa-optimization, it would be desirable to be able to check whether a learned algorithm is implementing potentially dangerous optimization.

Current verification algorithms are primarily used to verify properties defined on input-output relations, such as checking invariants of the output with respect to user-definable transformations of the inputs. A primary motivation for much of this research is the failure of robustness against adversarial examples in image recognition tasks. There are both white-box algorithms,[(31)](https://intelligence.org/learned-optimization#bibliography) e.g. an SMT solver that in principle allows for verification of arbitrary propositions about activations in the network,[(32)](https://intelligence.org/learned-optimization#bibliography) and black-box algorithms[(33)](https://intelligence.org/learned-optimization#bibliography). Applying such research to mesa-optimization, however, is hampered by the fact that we currently don't have a formal specification of optimization.

**Corrigibility.** An AI system is _corrigible_ if it tolerates or assists with its human programmers in correcting itself.[(25)](https://intelligence.org/learned-optimization#bibliography) The current analysis of corrigibility has focused on how to define a utility function such that, if optimized by a rational agent, that agent would be corrigible. Our analysis suggests that even if such a corrigible objective function could be specified or learned, it is nontrivial to ensure that a system trained on that objective function would actually be corrigible. Even if the base objective function would be corrigible if optimized directly, the system may exhibit mesa-optimization, in which case the system's mesa-objective might not inherit the corrigibility of the base objective. This is somewhat analogous to the problem of utility-indifferent agents creating other agents that are not utility-indifferent.[(25)](https://intelligence.org/learned-optimization#bibliography) In [the fourth post](https://www.alignmentforum.org/s/r9tYkB2a8Fp4DN8yB/p/zthDPAjh9w6Ytbeks), we suggest a notion related to corrigibility—corrigible alignment—which is applicable to mesa-optimizers. If work on corrigibility were able to find a way to reliably produce corrigibly aligned mesa-optimizers, it could significantly contribute to solving the inner alignment problem.

**Comprehensive AI Services (CAIS).**[(11)](https://intelligence.org/learned-optimization#bibliography) CAIS is a descriptive model of the process by which superintelligent systems will be developed, together with prescriptive implications for the best mode of doing so. The CAIS model, consistent with our analysis, makes a clear distinction between learning (the base optimizer) and functionality (the learned algorithm). The CAIS model predicts, among other things, that more and more powerful general-purpose learners will be developed, which through a layered process will develop services with superintelligent capabilities. Services will develop services that will develop services, and so on. At the end of this “tree,” services for a specific final task are developed. Humans are involved throughout the various layers of this process so that they can have many points of leverage for developing the final service.

The higher-level services in this tree can be seen as meta-optimizers of the lower-level services. However, there is still the possibility of mesa-optimization—in particular, we identify two ways in which mesa-optimization could occur in the CAIS-model. First, a final service could develop a mesa-optimizer. This scenario would correspond closely to the examples we have discussed in this sequence: the base optimizer would be the next-to-final service in the chain, and the learned algorithm (the mesa-optimizer in this case), would be the final service (alternatively, we could also think of the entire chain from the first service to the next-to-final service as the base optimizer). Second, however, an intermediary service in the chain might also be a mesa-optimizer. In this case, this service would be an optimizer in _two respects:_ it would be the meta-optimizer of the service below it (as it is by default in the CAIS model), but it would also be a mesa-optimizer with respect to the service above it.

&nbsp;

## Conclusion

In this sequence, we have argued for the existence of two basic AI safety problems: the problem that mesa-optimizers may arise even when not desired (unintended mesa-optimization), and the problem that mesa-optimizers may not be aligned with the original system's objective (the inner alignment problem). However, our work is still only speculative. We are thus left with several possibilities:

1. If mesa-optimizers are very unlikely to occur in advanced ML systems (and we do not develop them on purpose), then mesa-optimization and inner alignment are not concerns.
2. If mesa-optimizers are not only likely to occur but also difficult to prevent, then solving both inner alignment and outer alignment becomes critical for achieving confidence in highly capable AI systems.
3. If mesa-optimizers are likely to occur in future AI systems by default, and there turns out to be some way of preventing mesa-optimizers from arising, then instead of solving the inner alignment problem, it may be better to design systems to not produce a mesa-optimizer at all. Furthermore, in such a scenario, some parts of the outer alignment problem may not need to be solved either: if an AI system can be prevented from implementing any sort of optimization algorithm, then there may be more situations where it is safe for the system to be trained on an objective that is not perfectly aligned with the programmer's intentions. That is, if a learned algorithm is not an optimizer, it might not optimize the objective to such an extreme that it would cease to produce positive outcomes.

Our uncertainty on this matter is a potentially significant hurdle to determining the best approaches to AI safety. If we do not know the relative difficulties of the inner alignment problem and the unintended optimization problem, then it is unclear how to adequately assess approaches that rely on solving one or both of these problems (such as Iterated Distillation and Amplification[(34)](https://intelligence.org/learned-optimization#bibliography) or AI safety via debate[(35)](https://intelligence.org/learned-optimization#bibliography)). We therefore suggest that it is both an important and timely task for future AI safety work to pin down the conditions under which the inner alignment problem and the unintended optimization problem are likely to occur as well as the techniques needed to solve them.

&nbsp;

_The full paper that this sequence is based on, "Risks from Learned Optimization in Advanced Machine Learning Systems," is now [available on arXiv](https://arxiv.org/abs/1906.01820)._

[Glossary](https://intelligence.org/learned-optimization/#glossary) | [Bibliography](https://intelligence.org/learned-optimization/#bibliography)