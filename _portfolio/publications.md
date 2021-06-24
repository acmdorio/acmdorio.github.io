---
title: "Publications"
excerpt: "List of scientific texts with my name on them"
last_modified_at: 2021-06-03
header:
  teaser: /assets/images/heatmap.png
classes: wide
---

#### [Relying on a rate constraint to reduce Motion Estimation complexity](https://doi.org/10.1109/ICASSP39728.2021.9414799) [[PDF](https://arxiv.org/pdf/2102.09656.pdf)]
**IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)**<br>
**Abstract:** This paper proposes a rate-based candidate elimination strategy for Motion Estimation, which is considered one of the main sources of encoder complexity. We build from findings of previous works that show that selected motion vectors are generally near the predictor to propose a solution that uses the motion vector bitrate to constrain the candidate search to a subset of the original search window, resulting in less distortion computations. The proposed method is not tied to a particular search pattern, which makes it applicable to several ME strategies. The technique was tested in the VVC reference software implementation and showed complexity reductions of over 80% at the cost of an average 0.74% increase in BD-Rate with respect to the original TZ Search algorithm in the LDP configuration.
{: .text-justify}

#### [Eliminação de Candidatos Baseada em Taxa para Algoritmos de Estimação de Movimento na Codificação de Vídeo](https://sol.sbc.org.br/journals/index.php/reic/article/view/2080) [[PDF](https://sol.sbc.org.br/journals/index.php/reic/article/view/2080/1756)]
**REIC: Artigos do 40º Concurso de Trabalhos de Iniciação Científica (CTIC/CSBC)**<br>
**Resumo:** Este trabalho propõe e avalia uma técnica dedicada à redução do espaço de busca da Estimação de Movimento, uma das etapas mais importantes na codificação de vídeo. Partindo de evidências na literatura que indicariam uma correlação entre o custo estimado da representação de vetores de movimento e as decisões do codificador, o algoritmo proposto utiliza um critério de eliminação de candidatos considerando somente a taxa de bits dos seus respectivos vetores. A técnica foi avaliada no software de referência do padrão VVC e demonstrou, em uma das configurações do codificador, reduções de mais de 80% na área de busca da Estimação de Movimento, com perdas médias na eficiência de codificação de apenas 0,74% em relação ao algoritmo original.
{: .text-justify}
