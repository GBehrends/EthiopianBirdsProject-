
#### R Script for Generating RAxML Pipeline by Joseph Manthey @ https://github.com/jdmanthey/certhia_phylogeography/blob/main/08a_phylo_stats_50kbp.r
## Modify for your own directory as well as with the window size you want. This will generate a shell script to run RAxML on windowed gene trees of a 
## specified size. 

options(scipen=999)
	project_directory <- <directory to place sh script outputs in> 
	directory_name <- "species"
	cluster <- <name of computing cluster>
	max_number_jobs <- 1000
	n_tasks <- "6"
	output_sh <- "phylo50KBP_array.sh"
	
	# Location of VCF files to be used and the vcf to get the header from for all windows
	VCF_location <- 
	start_VCF <- 
	
	# Where to put the popmap containing individuals and sampling locations. 
	popmap_location <- paste(project_directory, "/species/Group_PopMap.txt", sep = "")
	
	# read in reference index
	# filtered to only include genotyped chromosomes
	ref_index <- read.table(<path to file>, stringsAsFactors=F)
	
	# define window size for gene trees 
	window_size <- 50000


###########################################################################################	
	# make directories
	# dir.create(directory_name)
	
	# define intervals and write to helper files
	tree_helper1 <- list()
	tree_helper2 <- list()
	tree_helper3 <- list()
	counter <- 1
	for(a in 1:nrow(ref_index)) {
		a_start <- 1
		a_end <- a_start + window_size - 1
		a_max <- ref_index[a,2]
		a_windows <- ceiling((a_max - a_start) / window_size)
		a_chromosome <- ref_index[a,1]
		
		# loop for defining helper info for each window
		for(b in 1:a_windows) {
			if(b == a_windows) {
				a_end <- a_max
			}
			tree_helper1[[counter]] <- a_chromosome
			tree_helper2[[counter]] <- a_start
			tree_helper3[[counter]] <- a_end

			a_start <- a_start + window_size
			a_end <- a_end + window_size
			counter <- counter + 1
		}
	}
	tree_helper1 <- unlist(tree_helper1)
	tree_helper2 <- unlist(tree_helper2)
	tree_helper3 <- unlist(tree_helper3)
	
	# calculate number of array jobs
	if(length(tree_helper3) > max_number_jobs) {
		n_jobs_per_array <- ceiling(length(tree_helper3) / max_number_jobs)
		n_array_jobs <- ceiling(length(tree_helper3) / n_jobs_per_array)
	} else {
		n_array_jobs <- length(tree_helper3)
		n_jobs_per_array <- 1
	}
	
	tree_helper1 <- c(tree_helper1, rep("x", n_jobs_per_array - length(tree_helper3) %% n_jobs_per_array))
	tree_helper2 <- c(tree_helper2, rep(1, n_jobs_per_array - length(tree_helper3) %% n_jobs_per_array))
	tree_helper3 <- c(tree_helper3, rep(1, n_jobs_per_array - length(tree_helper3) %% n_jobs_per_array))
	length(tree_helper3)
	write(tree_helper1, file=paste(directory_name, "/tree_helper_chrom.txt", sep=""), ncolumns=1)
	write(tree_helper2, file=paste(directory_name, "/tree_helper_start.txt", sep=""), ncolumns=1)
	write(tree_helper3, file=paste(directory_name, "/tree_helper_end.txt", sep=""), ncolumns=1)

	# write the array script
	a.script <- paste(directory_name, "/", output_sh, sep="")
	write("#!/bin/sh", file=a.script)
	write("#SBATCH --chdir=./", file=a.script, append=T)
	write(paste("#SBATCH --job-name=", "phylo", sep=""), file=a.script, append=T)
	write(paste("#SBATCH --nodes=1 --ntasks=", n_tasks, sep=""), file=a.script, append=T)
	write(paste("#SBATCH --partition ", cluster, sep=""), file=a.script, append=T)
	write("#SBATCH --time=48:00:00", file=a.script, append=T)
	write("#SBATCH --mem-per-cpu=8G", file=a.script, append=T)
	write(paste("#SBATCH --array=1-", n_array_jobs, sep=""), file=a.script, append=T)
	write("", file=a.script, append=T)
	
	write(paste("# Original num of jobs ->", n_array_jobs), file=a.script, append=T)
	write("", file=a.script, append=T)
	
	write("# Activate Conda environment and modules", file=a.script, append=T)
	write(". ~/conda/etc/profile.d/conda.sh", file=a.script, append=T)
	write("conda activate vcftools", file=a.script, append=T)
	write("", file=a.script, append=T)
	write("module load gcc/10.1.0", file=a.script, append=T)
	write("module load r/4.0.2", file=a.script, append=T)
	write("", file=a.script, append=T)

	write("# Set the number of runs that each SLURM task should do", file=a.script, append=T)
	write(paste("PER_TASK=", n_jobs_per_array, sep=""), file=a.script, append=T)
	write("", file=a.script, append=T)
	
	write("# Calculate the starting and ending values for this task based", file=a.script, append=T)
	write("# on the SLURM task and the number of runs per task.", file=a.script, append=T)
	write("START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))", file=a.script, append=T)
	write("END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))", file=a.script, append=T)
	write("", file=a.script, append=T)
	
	write("# Print the task and run range", file=a.script, append=T)
	write("echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM", file=a.script, append=T)
	write("", file=a.script, append=T)

	write("# Run the loop of runs for this task.", file=a.script, append=T)	
	write("for (( run=$START_NUM; run<=$END_NUM; run++ )); do", file=a.script, append=T)
	write("\techo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run", file=a.script, append=T)
	write("", file=a.script, append=T)
	
	write("\tchrom_array=$( head -n${run} tree_helper_chrom.txt | tail -n1 )", file=a.script, append=T)
	write("", file=a.script, append=T)
	write("\tstart_array=$( head -n${run} tree_helper_start.txt | tail -n1 )", file=a.script, append=T)
	write("", file=a.script, append=T)
	write("\tend_array=$( head -n${run} tree_helper_end.txt | tail -n1 )", file=a.script, append=T)
	write("", file=a.script, append=T)
	
	
	# add header to output file
	header <- paste('\tgunzip -cd ', VCF_location, "/", start_VCF, ' | grep "#" > ', project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.vcf", sep="")
	write(header, file=a.script, append=T)
	write("", file=a.script, append=T)
	
	#tabix command
	tabix_command <- paste("\ttabix ", VCF_location, "/${chrom_array}.vcf.gz ${chrom_array}:${start_array}-${end_array} >> ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.vcf", sep="")
	write(tabix_command, file=a.script, append=T)
	write("", file=a.script, append=T)
	
	# bcftools command
	bcf_tools_command <- paste("\tbcftools query -f '%POS\\t%REF\\t%ALT[\\t%GT]\\n' ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.vcf > ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf", sep="")
	write(bcf_tools_command, file=a.script, append=T)
	write("", file=a.script, append=T)
	
	# Rscript command for stats
	rscript_command <- paste("\tRscript calculate_windows.r ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf", " ", popmap_location, sep="")
	write(rscript_command, file=a.script, append=T)
	write("", file=a.script, append=T)
	
	# Rscript command for fasta creation
	rscript_command <- paste("\tRscript create_fasta.r ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf", " ", popmap_location, sep="")
	write(rscript_command, file=a.script, append=T)
	write("", file=a.script, append=T)
	
	# sed command (writing this command in R does not work at the moment. The asterisk is tricky. Will have to manually edit sh scripts later with:
	# sed -i 's/\*/?/g' <output fasta file path> 
	
	# raxml commands
	raxml_command <- paste("\t/lustre/work/johruska/miniconda2/bin/raxmlHPC-PTHREADS-SSE3 -T ", n_tasks, " -f a -x 150 -m GTRCAT -p 253 -N 100 -s", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.fasta -n ${chrom_array}__${start_array}__${end_array}.tre -w ", project_directory, "/", directory_name, "/windows/", sep="")
	write(raxml_command, file=a.script, append=T)
	write("", file=a.script, append=T)
	
	# remove unnecessary files at end
	write(paste("\trm ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.vcf", sep=""), file=a.script, append=T)
	write(paste("\trm ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf", sep=""), file=a.script, append=T)
	write(paste("\trm ", project_directory, "/", directory_name, "/windows/${chrom_array}__${start_array}__${end_array}.fasta", sep=""), file=a.script, append=T)
	write(paste("\trm ", project_directory, "/", directory_name, "/windows/RAxML_bestTree.${chrom_array}__${start_array}__${end_array}.tre", sep=""), file=a.script, append=T)
	write(paste("\trm ", project_directory, "/", directory_name, "/windows/RAxML_bipartitionsBranchLabels.${chrom_array}__${start_array}__${end_array}.tre", sep=""), file=a.script, append=T)
	write(paste("\trm ", project_directory, "/", directory_name, "/windows/RAxML_info.${chrom_array}__${start_array}__${end_array}.tre", sep=""), file=a.script, append=T)
	write("", file=a.script, append=T)
	
	# finish
	write("done", file=a.script, append=T)

	
