# key\_word\_search
kaldi kws pipline



## 需要安装F4DE   
- 1 apt-get install perl gnuplot libxml2 sqlite rsync curl  
- 2 curl -L https://cpanmin.us | perl -  App::cpanminus  
- 3 git clone https://github.com/usnistgov/F4DE.git  cd F4DE  
- 4 make perl_install  make install    
- 5 添加环境变量  
```
vi  ~/.bashrc  
[PATH=$PATH:xxx/F4DE/bin  export PATH]  
source ~/.bashrc
```   

## 需要准备如下3个文件   
`kwlist.xml` 、`ecf.xml` 、`rttm`
 
脚本使用 kaldi/egs/babel/s5d 目录下的脚本  
# step1 

对测试集先对齐  比如拿训练的qimeng1为例

```
datadir = /root/data/nlp_audio/kaldi/egs/qimengke1
```

```
steps/align_fmllr.sh --nj 5 --cmd "run.pl --mem 4G" data/dev_clean_2 data/lang exp/tri3b exp/tri3b_ali_dev_clean_2
```
# step2 
生成kwlist 、ecf、 rttm 
## s2.1 
```
    ./genkwlist.sh  生成kwlist.xml,准备一个keyword.txt里面写入keyword即可
```
## s2.2
```
       ./create_ecf_file.sh data/dev_clean_2/wav.scp data/ecf.xml
``` 
## s2.3  

其中make_L_align.sh第一个参数需要设置对 data/local/lang_tmp  在exp目录下需要有测试集的text文件   


```  
   ./ali_to_rttm.sh data/dev_clean_2 data/lang exp/tri3b_ali_dev_clean_2
```
# step3  
基础KWS 数据准备(无G2P模型)

## s3.1   
缺少segments文件 可由wav的dur产生  

``` 
    awk -F " " '{printf("%s %s 0.0 %s\n",$1,$1,$2)}'  utt2dur  >segments
```
## s3.2
```
local/kws_setup.sh --case_insensitive true \
 --rttm-file exp/tri3b_ali_dev_clean_2/rttm \
data/ecf.xml \
data/kwlist.xml \
data/lang \
data/dev_clean_2
```

# step4  Indexing and searching  

```
local/kws_search.sh --cmd "run.pl --mem 4G"    \
--max-states 150000 --min-lmwt 8               \ 
--max-lmwt 12 --skip-scoring false \  
--indices-dir exp/tri3b/decode_nosp_tglarge_dev_clean_2/kws_indices  \  
data/lang \  
data/dev_clean_2 \
exp/tri3b/decode_nosp_tglarge_dev_clean_2
```



