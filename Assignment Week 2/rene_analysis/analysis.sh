#!/bin/bash

# Bash script doing metagenome analysis

# Author(s): Rene Kmiecinski <r.w.kmiecinski@gmail.com>

#MIT License
#
#Copyright (c) 2019 Rene Kmiecinski
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in all
#copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#SOFTWARE.

set -eEuo pipefail

SOURCE="$( realpath "${BASH_SOURCE[0]}" )"
SOURCE_DIR="$( dirname "$SOURCE" )"
CONDA_ACTIVE=0
RET_VAL=0
ERROR_STATE=0
ReExec=0
NeedCleanup=0
OutputFolder="${1:-$SOURCE_DIR}"
OLDPATH=$PATH
CONDA_ACTIVATE="$(which activate)"
SentinelPath="${OutputFolder}/.sentinel/"


# Conda Environments

FITHIC_ENV="${SOURCE_DIR}/../week2_fithic2_env/"
FITHIC_ENV_SETUP="${SOURCE_DIR}/../setup_env.sh"
# Utility Functions {{{

eecho(){
    (>&2 echo "$@")
}

#unsetvars #### == Terminate Script == ####

stop_process(){
    local rv=$RET_VAL
    export PATH=$OLDPATH
    while [ $CONDA_ACTIVE -gt 0 ]; do
        deactivate_conda
    done
    unset OLDPATH OutputFolder SOURCE CONDA_ACTIVE SOURCE_DIR SentinelPath
    unset ERROR_STATE ReExec NeedCleanup FITHIC_ENV FITHIC_ENV_SETUP
    exit $rv
}

clean_up(){
    echo cleanup
}

had_error(){
    set +x
    ERROR_TYPE=1
    local errortype=""
    local prov_msg="${2:-""}"
    local msg=""
    case $1 in
        1)
            eecho "$prov_msg"
            errortype="RUNTIME ERROR:"
            local call=( $(caller) )
            # print surrounding lines of code
            # Stack Overflow
            # https://unix.stackexchange.com/questions/39623/trap-err-and-echoing-the-error-line
            # Thanks to unpythonic
            # https://unix.stackexchange.com/users/8365/unpythonic
            msg=$(
                awk 'NR>L-4 && NR<L+4 {
                        printf "%-5d%3s%s\n",NR,(NR==L?">>>":""),$SOURCE
                     }' L="${call[0]}" "$SOURCE" )
            prov_msg="Line "${call[@]}"\n"
        ;;
        2)
            errortype="USER INTERUPT:"
        ;;
        3)
            errortype="STRANGE ERROR:"
        ;;
    esac
    eecho -e "$errortype" "$prov_msg""$msg"
    stop_process
}



activate_conda(){
    echo $@
    set +ue
    source "$CONDA_ACTIVATE" "$@"
    set -ue
    CONDA_ACTIVE=$((CONDA_ACTIVE+1))
    echo CONDA ENVIRONMENTS "$CONDA_ACTIVE"
}

deactivate_conda(){
    set +ue
    conda deactivate
    set -ue
    CONDA_ACTIVE=$((CONDA_ACTIVE-1))
    echo ACTIVE CONDA ENVIRONMENTS $CONDA_ACTIVE
}


mkcl_suboutdir(){
    local outfolder="${OutputFolder}/${1}"
    (rm -r "$outfolder" 2> /dev/null || true )
    mkdir -p "$outfolder"
    echo "$outfolder"
}

mk_suboutdir(){
    local outfolder="${OutputFolder}/${1}"
    mkdir -p "$outfolder"
    echo "$outfolder"
}
# }}}

trap 'had_error 2 "User requested Interupt"' SIGINT
trap 'had_error 1' ERR


#1 ####  == Setup processing

setup_processing(){
    mkdir -p "${OutputFolder}"
    cd "${OutputFolder}"

}



#2 ####  == main order of processes ==  ####

main_processing(){
    step get_data 1_downloaded_data $ReExec
    #  Actual FitHic Analysis Steps
    activate_conda "$FITHIC_ENV"
    run_yeast_example
    run_rao_chr5_example
    deactivate_conda
}

run_yeast_example(){
    (
        step compute_bias_yeast 2.0_compute_bias_yeast $ReExec
        step run_fithic_yeast 2.1_fithic_yeast $ReExec
        step create_html_report_yeast 2.2_fihic_report $ReExec
        step generate_washu_bed_yeast 2.3_washu_bed_yeast $ReExec
    )
}

run_rao_chr5_example(){
    (
        step compute_bias_rao_chr5 3.0_compute_bias_rao_chr5 $ReExec
        step run_fithic_rao_chr5 3.1_fithic_rao_chr5 $ReExec
        ( step merge_significant_rao_chr5 3.1.1_merge_significant_rao_chr5 1 )#$ReExec
        step create_html_report_rao_chr5 3.2_fihic_report_rao_chr5 $ReExec
        step generate_washu_bed_rao_chr5 3.3_washu_bed_rao_chr5 $ReExec
    )
}

run_dixon_example(){
    (
        step compute_bias_dixon 4.0_compute_bias_dixon $ReExec
        step run_fithic_dixon 4.1_fithic_dixon $ReExec
        step create_html_report_dixon 4.2_fihic_report_dixon $ReExec
    )
}


#3 #### === actual analysis functions === ####

get_data(){
  local outfolder="$(mk_suboutdir study_data)"
  cd "$outfolder"
  (
    set -x
    wget -nc http://fithic.lji.org/fithic_protocol_data.tar.gz
    tar -xvzf fithic_protocol_data.tar.gz
    set +x
  ) |& tee get_data.log

}

#  Example Yeast Workflow

compute_bias_yeast(){
    local outfolder="$(mk_suboutdir yeast_example_analysis/biasValues)"
    local path_to_data="fithic_protocol_data/data"
    local DATADIR="${OutputFolder}/study_data/${path_to_data}"
    cd "$outfolder"
    (
    set -x
    HiCKRy.py \
        -i "${DATADIR}/contactCounts/Duan_yeast_EcoRI.gz" \
        -f "${DATADIR}/fragmentMappability/Duan_yeast_EcoRI.gz" \
        -o Duan_yeast_EcoRI.gz
    set +x
    ) |& tee yeast_bias_hickry.log
}

run_fithic_yeast(){
    local outfolder="$(mk_suboutdir yeast_example_analysis)"
    local path_to_data="fithic_protocol_data/data"
    local DATADIR="${OutputFolder}/study_data/${path_to_data}"
    cd "$outfolder"
    (
    set -x
    fithic \
        -i "$DATADIR"/contactCounts/Duan_yeast_EcoRI.gz \
        -f "$DATADIR"/fragmentMappability/Duan_yeast_EcoRI.gz \
        -t "${outfolder}/biasValues/Duan_yeast_EcoRI.gz" \
        -r 0 \
        -o Duan_yeast_EcoRI \
        -l Duan_yeast_EcoRI \
        -p 2 \
        -v
    set +x
    ) |& tee fithic_yeast.log
}

create_html_report_yeast(){
    local outfolder="$(mkcl_suboutdir yeast_example_analysis/html_report)"
    local fithic_out="${OutputFolder}/yeast_example_analysis/Duan_yeast_EcoRI"
    cd "$outfolder"
    (
    set -x
    createFitHiCHTMLout.sh  Duan_yeast_EcoRI  2 \
       "$fithic_out"
    set +x
    ) |& tee fithic_yeast.log
}


generate_washu_bed_yeast(){
    local libname="Duan_yeast_EcoRI"
    local subproject="yeast_example_analysis"
    local QVAL="1e-10"
    generate_washu_bed "$libname" "$subproject" "$QVAL"

}

#  Example Rao Chromosome 5 Workflow

compute_bias_rao_chr5(){
    local outfolder="$(mk_suboutdir rao_chr5_example_analysis/biasValues)"
    local path_to_data="fithic_protocol_data/data"
    local DATADIR="${OutputFolder}/study_data/${path_to_data}"
    cd "$outfolder"
    (
    set -x
    HiCKRy.py \
        -i "${DATADIR}/contactCounts/Rao_GM12878-primary-chr5_5kb.gz" \
        -f "${DATADIR}/fragmentMappability/Rao_GM12878-primary-chr5_5kb.gz" \
        -o Rao_GM12878-primary-chr5_5kb.gz
    set +x
    ) |& tee rao_chr5_bias_hickry.log
}

run_fithic_rao_chr5(){
    local outfolder="$(mk_suboutdir rao_chr5_example_analysis)"
    local path_to_data="fithic_protocol_data/data"
    local DATADIR="${OutputFolder}/study_data/${path_to_data}"
    cd "$outfolder"
    (
    set -x
    fithic \
        -i "${DATADIR}/contactCounts/Rao_GM12878-primary-chr5_5kb.gz" \
        -f "${DATADIR}/fragmentMappability/Rao_GM12878-primary-chr5_5kb.gz" \
        -t "${outfolder}/biasValues/Rao_GM12878-primary-chr5_5kb.gz" \
        -r 5000\
        -o Rao_GM12878-primary-chr5_5kb\
        -l Rao_GM12878-primary-chr5_5kb\
        -U 1000000\
        -L 15000\
        -v
    set +x
    ) |& tee fithic_rao_chr5.log
}




merge_significant_rao_chr5(){
    local libname="Rao_GM12878-primary-chr5_5kb"
    local subproject="rao_chr5_example_analysis"
    local FDR="0.01"
    merge_significant_fithic "$libname" "$subproject" "$FDR"
}


create_html_report_rao_chr5(){
    local outfolder="$(mkcl_suboutdir rao_chr5_example_analysis/html_report)"
    local fithic_out="${OutputFolder}/rao_chr5_example_analysis/Rao_GM12878-primary-chr5_5kb"
    cd "$outfolder"
    (
    set -x
    createFitHiCHTMLout.sh Rao_GM12878-primary-chr5_5kb 1 \
       "$fithic_out"
    set +x
    ) |& tee fithic_rao_chr5.log
}




generate_washu_bed_rao_chr5(){
    local libname="Rao_GM12878-primary-chr5_5kb"
    local subproject="rao_chr5_example_analysis"
    local QVAL="1e-10"
    generate_washu_bed "$libname" "$subproject" "$QVAL"

}


merge_significant_fithic(){
    local libname="$1"
    local subproject="$2"
    local FDR="$3"
    local outfolder="$(mkcl_suboutdir ${subproject}/merged_significant)"
    local fithic_out="${OutputFolder}/${subproject}/${libname}"
    cd "$outfolder"
    (
    set -x
    set +eE
    ls -A1 "${fithic_out}/${libname}.spline_pass"*.significances.txt.gz \
         | while read SigFile; do
                local pass="$(grep -Eoh '(pass[\d]*).' <<< "$SigFile")"
                local res="$(grep -Eoh 'res([0-9]+)' <<< "$SigFile")"
                res=${res##res}
                merge-filter.sh \
                    "$SigFile" "$res" \
                    "${libname}-${pass}-merged.gz" $FDR "${UTILITYFOLDER}"
            done
    set +x
    set -eE
    ) |& tee merge_significant_fithic.log

}


generate_washu_bed(){
    local libname="$1"
    local subproject="$2"
    local QVAL="$3"
    local outfolder="$(mkcl_suboutdir ${subproject}/washu_bed)"
    local fithic_out="${OutputFolder}/${subproject}/${libname}"
    cd "$outfolder"
    (
    set -x
    set +eE
    ls -A1 "${fithic_out}/${libname}.spline_pass"*.significances.txt.gz \
         | while read SigFile; do
                local pass="$(grep -Eoh '(pass[\d]*).' <<< "$SigFile")"
                zcat "${SigFile}" \
                    | awk -vq="$QVAL" '{if($7 < q) {print $0}}' \
                    | awk -F ['\t'] \
                    '{
                        if(NR>1) {
                            if($NF>0){
                                print $1"\t"($2-1)"\t"($2+1)"\t"$3":"($4-1)"-"($4+1)","(-log($7)/log(10))"\t"(NR-1)"\t."
                            } else {
                                print $1"\t"($2-1)"\t"($2+1)"\t"$3":"($4-1)"-"($4+1)",500\t"(NR-1)"\t."
                            }
                        }
                    }' \
                    | sort -k1,1 -k2,2n > washu_browser_format_${pass}.bed
                bgzip washu_browser_format_${pass}.bed
                tabix -f -p bed washu_browser_format_${pass}.bed.gz
            done
    set +x
    set -eE
    ) |& tee generate_washu_bed.log

}

# Example Dixon Workflow
compute_bias_dixon(){
    local outfolder="$(mk_suboutdir dixon_example_analysis/biasValues)"
    local path_to_data="fithic_protocol_data/data"
    local DATADIR="${OutputFolder}/study_data/${path_to_data}"
    cd "$outfolder"
    (
    set -x
    HiCKRy.py \
        -i "${DATADIR}/contactCounts/Dixon_IMR90-wholegen_40kb.gz" \
        -f "${DATADIR}/fragmentMappability/Dixon_IMR90-wholegen_40kb.gz" \
        -o Dixon_IMR90-wholegen_40kb.gz
    set +x
    ) |& tee dixon_bias_hickry.log
}

run_fithic_dixon(){
    local outfolder="$(mk_suboutdir dixon_example_analysis)"
    local path_to_data="fithic_protocol_data/data"
    local DATADIR="${OutputFolder}/study_data/${path_to_data}"
    cd "$outfolder"
    (
    set -x
    fithic \
        -i "${DATADIR}/contactCounts/Dixon_IMR90-wholegen_40kb.gz" \
        -f "${DATADIR}/fragmentMappability/Dixon_IMR90-wholegen_40kb.gz" \
        -t "${outfolder}/biasValues/Dixon_IMR90-wholegen_40kb.gz" \
        -r 40000 \
        -o Dixon_IMR90-wholegen_40kb/intraChromosomal \
        -l Dixon_IMR90-wholegen_40kb-intraChromosomal \
        -U 10000000 \
        -L 80000 \
        -x intraOnly \
        -v
    set +x
    ) |& tee fithic_dixon.log
}

create_html_report_dixon(){
    local outfolder="$(mkcl_suboutdir dixon_example_analysis/html_report)"
    local fithic_out="${OutputFolder}/dixon_example_analysis/Dixon_IMR90-wholegen_40kb/intraChromosomal"
    cd "$outfolder"
    (
    set -x
    createFitHiCHTMLout.sh  Duan_dixon_EcoRI  2 \
       "$fithic_out"
    set +x
    ) |& tee fithic_dixon.log
}

step(){
    # function governing analysis steps
    local a_step="$1"
    local sentinel="$2"
    local sentinel_path="${SentinelPath}/$sentinel"
    mkdir -p "${SentinelPath}"
    #echo $sentinel_path
    if [ ! -f "$sentinel_path" ] || ( [ $# -gt 2 ] && [[ $3 == 1 ]] ) ; then
        case $a_step in
            get_data)
                get_data
                ;;
            compute_bias_yeast)
                compute_bias_yeast
                ;;
            run_fithic_yeast)
                run_fithic_yeast
                ;;
            create_html_report_yeast)
                create_html_report_yeast
                ;;
            generate_washu_bed_yeast)
                generate_washu_bed_yeast
                ;;
            compute_bias_dixon)
                compute_bias_dixon
                ;;
            run_fithic_dixon)
                run_fithic_dixon
                ;;
            create_html_report_dixon)
                create_html_report_dixon
                ;;
            compute_bias_rao_chr5)
                compute_bias_rao_chr5
                ;;
            run_fithic_rao_chr5)
                run_fithic_rao_chr5
                ;;
            merge_significant_rao_chr5)
                merge_significant_rao_chr5
                ;;
            create_html_report_rao_chr5)
                create_html_report_rao_chr5
                ;;
            generate_washu_bed_rao_chr5)
                generate_washu_bed_rao_chr5
                ;;
            *)
                had_error 1 "${a_step} - analysis step unknown"
            ;;
        esac
        [ $ERROR_STATE -eq 1 ] && had_error 3 \
            "${a_step} - had error not caught by bash strict mode"
        ReExec=1
        touch "$sentinel_path"
    else
        echo SKIPPING $a_step
    fi
}

echo starting
setup_processing
main_processing
stop_process
