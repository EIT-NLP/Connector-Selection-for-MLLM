<div align="center">

# To Preserve or To Compress: An In-Depth Study of Connector Selection in Multimodal Large Language Models

## 1. Introduction
In recent years, multimodal large language models (MLLMs) have garnered significant attention from both industry and academia. However, there is still considerable debate on constructing MLLM architectures, particularly regarding the selection of appropriate connectors for perception tasks of varying granularities. This paper systematically investigates the impact of connectors on MLLM performance. 

<p align="center">
  <img src="image/introduction.png" width="90%" />
  <p align="center">Comparison of radar chart performance at 224, 336, and 448 resolutions across coarse-grained perception, fine-grained perception, and reasoning tasks on MMBench. Each task includes four sub-tasks: Image Quality, Image Scene, Image Style, and Image Topic for coarse-grained perception; Action Recognition, Celebrity Recognition, Object Localization, and OCR for fine-grained perception; and Function Reasoning, Identity Reasoning, Social Relation, and Structuralized Image-Text Understanding for reasoning tasks.</p>
</p>

Specifically, we classify connectors into feature-preserving and feature-compressing types. Utilizing a unified classification standard, we categorize sub-tasks from three comprehensive benchmarks, MMBench, MME, and SEED-Bench, into three task types: coarse-grained perception, fine-grained perception, and reasoning, and evaluate the performance. Our findings reveal that feature-preserving connectors excel in *fine-grained perception* tasks due to their ability to retain detailed visual information. In contrast, feature-compressing connectors, while less effective in fine-grained perception tasks, offer significant speed advantages and perform comparably in *coarse-grained perception* and *reasoning* tasks. These insights are crucial for guiding MLLM architecture design and advancing the optimization of MLLM architectures.
