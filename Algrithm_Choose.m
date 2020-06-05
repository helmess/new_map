function [ globel ] = Algrithm_Choose( startp,endp,model )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %����Ⱦɫ��
%123
model.startp=startp;
model.endp=endp;

my_chromosome.pos=[];
my_chromosome.alpha=[];
my_chromosome.beta=[];
my_chromosome.atkalpha=[];
my_chromosome.atkbeta=[];
my_chromosome.T=[];
my_chromosome.sol=[];
my_chromosome.cost=[];
my_chromosome.ETA=[];
my_chromosome.IsFeasible=[];
my_chromosome.AllPos=[];
%��ʼȾɫ�����
chromosome = repmat(my_chromosome,model.NP,1);
%�Ӵ�Ⱦɫ��
next_chromosome = repmat(my_chromosome,model.NP,1);
%����Ⱦɫ��
AllChromosome = repmat(my_chromosome,model.NP*2,1);
%��Ⱥ����Ӧ��ֵ
seeds_fitness=zeros(1,model.NP);
%ȫ������
globel.cost =inf;
%��Ⱥ��ʼ��
h= waitbar(0,'initial chromosome');
for i=1:model.NP
  flag =0;
  while flag ~=1
  %��ʼ���ǶȺ�ʱ��
  [chromosome(i).alpha,chromosome(i).T,chromosome(i).beta] = InitialChromosome(model,i);
  %���ݽǶȺ�DH�����ö�Ӧ����
  [chromosome(i).pos] = Angel2Pos(chromosome(i),model);
    %�γɿ�ִ��·����,����ʵ�ʵ�·�����ܱ���ʼ��Ŀ���ֱ�߾���Զ,��������ʱ��T
   [chromosome(i).T] =Modify_Chromosom_T(chromosome(i),model);
   %���¼����µ�pos
  [chromosome(i).pos] = Angel2Pos(chromosome(i),model);
  %����������
  [flag,chromosome(i).atkalpha,chromosome(i).atkbeta] = IsReasonble(chromosome(i),model);
  
  chromosome(i).IsFeasible = (flag==1);
  end

  %����ÿ������Э�����������Ӧ��ֵ��ÿ����ľ���������
  [chromosome(i).cost,chromosome(i).sol] = FitnessFunction(chromosome(i),model);
  %��¼���н����Ӧ��ֵ����Ϊ���̶ĵļ���
  seeds_fitness(i) = chromosome(i).cost;
  h=waitbar(i/model.NP,h,[num2str(i),':chromosomes finished']);
  if globel.cost >chromosome(i).cost
     globel.cost =chromosome(i).cost;
  end
end
close(h)
%�����ʼ������
model.seeds_fitness=seeds_fitness;
model.chromosome=chromosome ;
model.next_chromosome=next_chromosome;
model.AllChromosome=AllChromosome;
model.globel =globel;
% %%����gaѡ��Ľ��Ͳ��Ľ��Ĳ���
% model.std_ga=1;
% std_globel_ga= Choose_GA(model);
% PlotSolution(std_globel_ga.sol,model);
model.alg_choose=1;
globel_ga=GA(model);
PlotSolution(globel_ga.sol,model);
model.alg_choose=2;
p_global =GAPSO(model);
PlotSolution(p_global.sol,model);
model.alg_choose=3;
global_particle =PSO(model);
PlotSolution(global_particle.sol,model);
figure;
plot(globel_ga.best_plot);
hold on;
plot(p_global.best_plot);
hold on;
plot(global_particle.best_plot);
legend('GA','GAPSO','PSO');
 
end
