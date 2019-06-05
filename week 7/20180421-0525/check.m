clear all;close all;clc

%% ��ȡ����

fprintf('���ڶ�ȡ����\n')

% ���������������Ҫ����
[~,~,nanchaoDATA]=xlsread("��������\pos�������б�20180421-0525.xls");    % ����Ҫ���ļ���ַ���ļ�����Ϊ���е������ļ���
[~,~,yikatongDATA01]=xlsread("һ��ͨ��������\������ˮ��ѯ.xls");          %����Ҫ���ļ���ַ���ļ�����Ϊһ��ͨ���ĵ������ļ���
[~,~,yikatongDATA02]=xlsread("һ��ͨ��������\������ˮ��ѯ02.xls");        %����Ҫ���ļ���ַ���ļ�����Ϊһ��ͨ���ĵ������ļ���
% ������

yikatongDATA=[yikatongDATA01
    yikatongDATA02(2:end,:)];  %��һ��ͨ���ĵ������ļ��ϲ�Ϊһ���ļ����ϳ�������ǰ̨pos���������������ļ���
clear yikatongDATA01 yikatongDATA02
fprintf('��ȡ�������\n')
%% �����ϳ�����ˮ
fprintf('���ڴ����ϳ�����ˮ\n')
nanchaoDATA_title=nanchaoDATA(1,:);
nanchaoDATA(1,:)=[];   %ɾ���ϳ��ļ��ĵ�һ��
nanchaoDATA(end,:)=[];%ɾ���ϳ��ļ������һ��

% ���������������Ҫ����
nanchaoDATA_momey=cell2mat(nanchaoDATA(:,11));%��ȡ�ϳ����������ÿ����ˮ�Ľ���11�У������ѵ�Ԫ���ʽת�������ָ�ʽ
% ������

nanchaoDATA_time=datetime(nanchaoDATA(:,1),'ConvertFrom','yyyy-MM-dd HH:mm:ss');%��ȡ�ϳ����������ÿ����ˮ��ʱ�䣨��1�У������ѵ�Ԫ���ʽת����ʱ���ʽ
fprintf('�ϳ�����ˮ�������\n')
%% �����ϳ�һ��ͨ����Ϊ0����
fprintf('���������ϳ�һ��ͨ����Ϊ0����\n')
nanchaoDATA_money_0=nanchaoDATA_title;
for i=size(nanchaoDATA_momey,1):-1:1
    fprintf('%.0f\n',i)
    if nanchaoDATA_momey(i,1)==0
        nanchaoDATA_money_0=[nanchaoDATA_money_0
            nanchaoDATA(i,:)];
        nanchaoDATA_momey(i,:)=[];
        nanchaoDATA_time(i,:)=[];
        nanchaoDATA(i,:)=[];
    end
end
fprintf('�����ϳ�һ��ͨ����Ϊ0�������\n')
%% ����һ��ͨ���ĵ���ˮ
fprintf('���ڴ���һ��ͨ���ĵ���ˮ\n')

% ���������������Ҫ����
yikatongDATA_title=yikatongDATA(2,:);%��¼����һ��ͨ�������ݵı���   ��������ʱ���ļ�������һ�У�����
yikatongDATA(1:2,:)=[];%ɾ��һ��ͨ�������ݵ�ǰ���б���   ��������ʱ���ļ�������һ�У�����
% ���������������Ҫ����

yikatongDATA_momey=[];
yikatongDATA_time=[];
for i=1:size(yikatongDATA,1)
    
    % ���������������Ҫ����
    yikatongDATA_momey(i,1)=str2double(cell2mat(yikatongDATA(i,6)));%����ڵ�6�У���ȡһ��ͨ�������������ÿ����ˮ�Ľ����ѵ�Ԫ���ʽת�������ָ�ʽ
    % ���������������Ҫ����
    
end

% ���������������Ҫ����
time1=yikatongDATA(:,13);%�����ڵ�13��
time2=yikatongDATA(:,14);%ʱ���ڵ�14��
% ���������������Ҫ����

time=string(time1)+' '+string(time2);
yikatongDATA_time=datetime(time,'InputFormat','yyyyMMdd HHmmss');%��ȡһ��ͨ�������������ÿ����ˮ��ʱ�䣬���ѵ�Ԫ���ʽת����ʱ���ʽ
clear time1 time2 time

fprintf('����һ��ͨ���ĵ���ˮ���\n')

%% ��ǰ����
fprintf('��ʼ����\n')
[nanchaoDATA_time,ind] = sort(nanchaoDATA_time);
nanchaoDATA_momey = nanchaoDATA_momey(ind,:);
nanchaoDATA = nanchaoDATA(ind,:);

[yikatongDATA_time,ind] = sort(yikatongDATA_time);
yikatongDATA_momey = yikatongDATA_momey(ind,:);
yikatongDATA = yikatongDATA(ind,:);
fprintf('�������\n')


%% �Ƚ���ˮ
fprintf('��ʼ�Ƚ���ˮ\n')
rightDATA_title= [nanchaoDATA_title yikatongDATA_title];
rightDATA={};
for i=size(nanchaoDATA_momey,1):-1:1
    fprintf('\n%.0f\n',i)
    for j=size(yikatongDATA_momey,1):-1:1
        
        time_between=abs(etime(datevec(nanchaoDATA_time(i,1)),datevec(yikatongDATA_time(j,1))));
        
        % ���������������Ҫ����
        if time_between<60*20   %�Ƚϼ��ʱ��С��20min�����ݣ�����ĵ�λ����s�������ȶ���ˮʱ��������ˮ��һ��ͨ��ˮ��ʱ������ޣ�С�����ֵ�Ļ��������Ϊ�ѽ���
         % ���������������Ҫ����   
            
            fprintf('%.0f,',time_between)
            if yikatongDATA_momey(j,1)==nanchaoDATA_momey(i,1)
                rightDATA= [rightDATA
                    nanchaoDATA(i,:) yikatongDATA(j,:)];
                nanchaoDATA(i,:)=[];
                yikatongDATA(j,:)=[];
                yikatongDATA_momey(j,:)=[];
                yikatongDATA_time(j,:)=[];
                nanchaoDATA_momey(i,:)=[];
                nanchaoDATA_time(i,:)=[];
                break
            end
        end
    end
end
fprintf('�Ƚ���ˮ���\n')
%% д���ļ�
fprintf('��ʼд���ļ�\n')

cell2csv('���˽������\nanchaoDATA_money_0.csv',nanchaoDATA_money_0);%д���ϳ���ˮ�У�һ��ͨ���Ϊ0������

rightDATA=[rightDATA_title
    rightDATA];
cell2csv('���˽������\rightDATA.csv',rightDATA);%д����ˮ�У����к�һ��ͨ������ˮ�����ͬ����ˮʱ����������ݣ�Ҳ������ȷ�����ݣ�

nanchaoDATA=[nanchaoDATA_title
    nanchaoDATA];
yikatongDATA=[yikatongDATA_title
    yikatongDATA];
cell2csv('���˽������\nanchaoDATA.csv',nanchaoDATA);%д����ˮ�У�ʣ��ĳ�����ˮ��Ҳ�����ڸ���ʱ�������棬û���ҵ���Ӧ��һ��ͨ���ĵ����ݣ���û�ж����ʵ����ݣ�
cell2csv('���˽������\yikatongDATA.csv',yikatongDATA);%д����ˮ�У�ʣ���һ��ͨ������ˮ��Ҳ�����ڸ���ʱ�������棬û���ҵ���Ӧ�ĳ�����ˮ�����ݣ���û�ж����ʵ����ݣ�

fprintf('д���ļ����\n')