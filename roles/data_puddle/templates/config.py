authentication=True
authentication_file = "${DESTINATION}/oauth.conf"
noindex=True

data_dir="${DESTINATION}/"
cache="${DESTINATION}/cache/"

browser="FINNGEN"
release="R${RELEASE}"
release_prev="R5"
title="FREEZE ${RELEASE} BETA"
page_title="FinnGen results"
logo='<img src="/static/images/finngen_loop1.gif" style="float: left; width: 60px; height: 60px; margin: -10px; margin-top: 8px" />'

show_ukbb=True
show_risteys=True

ld_server = 'http://api.finngen.fi'

database_conf = (
    { "annotation": { "TabixAnnotationDao": { "matrix_path": "${ANNOTATIONS_DIR}/r6/R6_annotated_variants_v1.gz" } } },
    
    { "result": { "TabixResultDao": { 'const_arguments': [ ("phenos","PHEWEB_PHENOS"),
                                                           ("matrix_path","MATRIX_PATH") ] } } },
    { "gnomad": { "TabixGnomadDao": { "matrix_path": "${ANNOTATIONS_DIR}/gnomad21/gnomad.genomes.r2.1.sites.liftover.b38.finngen.r2pos.af.ac.an.tsv.gz" } } },
    
    { "finemapping" : { "FineMappingMySQLDao": { "authentication_file": "${DESTINATION}/mysql.conf",
                                                 "base_paths": { "susie": "${FINEMAPPING_DIR}/susie/snp",
                                                                 "finemap": "${FINEMAPPING_DIR}/finemap/cred" } } } } ,
								 
    { "lof": { "LofMySQLDao": { "authentication_file": "${DESTINATION}/mysql.conf" } } },
    
    { "finemapping" : { "FineMappingMySQLDao": { "authentication_file": "${DESTINATION}/mysql.conf",
                                                 "base_paths": { "susie": "${FINEMAPPING_DIR}/susie/snp",
                                                                 "finemap": "${FINEMAPPING_DIR}/finemap/cred" } } } } ,
								 
    { "colocalization": { "ColocalizationDAO": { "db_url": "${DESTINATION}/mysql.conf" ,
                                                 "echo" : True  } } }
)

n_query_threads=4
report_conf = {"func_var_assoc_threshold":0.0001, "gene_top_assoc_threshold":0.0001}

locuszoom_conf = { "p_threshold": 0.05,
                   "prob_threshold": 0.0001,
                   "ld_service": "finngen",
                   "ld_max_window": 5000000,
                   "ld_ens_pop": "1000GENOMES:phase_3:FIN",
                   "ld_ens_window": 500,
                   "assoc_fields": [ "association:id",
                                     "association:chr",
                                     "association:position",
                                     "association:ref",
                                     "association:alt",
                                     "association:pvalue",
                                     "association:pvalue|neglog10_or_100",
                                     "association:beta",
                                     "association:sebeta",
                                     "association:rsid",
                                     "association:maf",
                                     "association:maf_cases",
                                     "association:maf_controls",
                                     "association:most_severe",
                                     "association:fin_enrichment",
                                     "association:INFO",
                                     "ld:state",
                                     "ld:isrefvar"],
                   "tooltip_html": """
                   <strong>{{association:id}}</strong><br/>
                   <strong>{{association:rsid}}</strong><br/>
                   <strong>{{association:most_severe}}</strong><br/>
                   <table>
                      <tbody>
                        <tr>
                            <td>phenotype</td>
                            <td><strong>PHENO</strong></td>
                        </tr>
                        <tr>
                            <td>p-value</td>
                            <td><strong>{{association:pvalue|scinotation}}</strong></td>
                        </tr>
                        <tr>
                            <td>beta</td>
                            <td><strong>{{association:beta}}</strong> ({{association:sebeta}})</td>
                        </tr>
                        <tr>
                            <td>MAF</td>
                            <td><strong>{{association:maf|percent}}</strong></td>
                        </tr>
                        <tr>
                            <td>MAF controls</td>
                            <td><strong>{{association:maf_controls|percent}}</strong></td>
                        </tr>
                        <tr>
                            <td>MAF cases</td>
                            <td><strong>{{association:maf_cases|percent}}</strong><br></td>
                        </tr>
                        <tr>
                            <td>FIN enrichment</td>
                            <td><strong>{{association:fin_enrichment}}</strong></td>
                        </tr>
                        <tr>
                            <td>INFO</td>
                            <td><strong>{{association:INFO}}</strong></td>
                        </tr>
                      </tbody>
                   </table>"""}

vis_conf = {"loglog_threshold": 10,
	    "info_tooltip_threshold": 0.8,
	    "manhattan_colors": ['rgb(53,0,212)', 'rgb(40, 40, 40)']}

gene_pheno_export_fields=["variant.varid",
                          "assoc.pval",
                          "assoc.beta",
                          "variant.annotation.rsids",
                          "pheno.category",
                          "pheno.num_cases",
                          "pheno.num_controls",
                          "pheno.phenocode",
                          "pheno.phenostring",
                          "variant.annotation.gnomad.AF_fin",
                          "variant.annotation.gnomad.AF_nfe",
                          "assoc.matching_results.ukbb.pval",
                          "assoc.matching_results.ukbb.n_cases"]

about_content='content/about.html'
coding_content='content/coding.html'
chip_content='content/chip.html'
lof_content='content/lof.html'
