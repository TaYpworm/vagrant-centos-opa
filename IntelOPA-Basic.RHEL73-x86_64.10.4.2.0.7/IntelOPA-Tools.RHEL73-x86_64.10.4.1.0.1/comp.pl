#!/usr/bin/perl
## BEGIN_ICS_COPYRIGHT8 ****************************************
## 
## Copyright (c) 2015, Intel Corporation
## 
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
## 
##     * Redistributions of source code must retain the above copyright notice,
##       this list of conditions and the following disclaimer.
##     * Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in the
##       documentation and/or other materials provided with the distribution.
##     * Neither the name of Intel Corporation nor the names of its contributors
##       may be used to endorse or promote products derived from this software
##       without specific prior written permission.
## 
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
## DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
## FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
## DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
## SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
## CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
## OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
## OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
## 
## END_ICS_COPYRIGHT8   ****************************************
#
## [ICS VERSION STRING: @(#) ./comp.pl 10_4_1_0_1 [04/30/17 13:35]
#use strict;
##use Term::ANSIColor;
##use Term::ANSIColor qw(:constants);
##use File::Basename;
##use Math::BigInt;
#
## ==========================================================================
#
#Installation Prequisites array for fast fabric
#and of tools component
my @oftools_prereq = (
			"glibc",
			"libgcc",
			"libibumad",
			"libibverbs",
			"libstdc++",
);
$comp_prereq_hash{'oftools_prereq'} = \@oftools_prereq;

my @fastfabric_prereq = (
			"atlas",
			"bash",
			"bc",
			"expat",
			"expect",
			"glibc",
			"libgcc",
			"libibumad",
			"libibverbs",
			"libstdc++",
			"ncurses-libs",
			"openssl-libs",
			"perl",
			"perl-Getopt-Long",
			"perl-Socket",
			"rdma",
			"tcl",
			"zlib",
			"qperf",
			"perftest",
);
$comp_prereq_hash{'fastfabric_prereq'} = \@fastfabric_prereq;

#!/usr/bin/perl
# BEGIN_ICS_COPYRIGHT8 ****************************************
# 
# Copyright (c) 2015, Intel Corporation
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# END_ICS_COPYRIGHT8   ****************************************

# [ICS VERSION STRING: @(#) ./comp.pl 10_4_1_0_1 [04/30/17 13:35]
use strict;
#use Term::ANSIColor;
#use Term::ANSIColor qw(:constants);
#use File::Basename;
#use Math::BigInt;


# ==========================================================================
# SHMEM Sample Applications sub-component installation

# remove the files built from source or installed
# (as listed in .files and .dirs)
# $0 = dirname relative to $ROOT
sub remove_shmem_apps($)
{
	my $dirname = shift();

	if ( -d "$ROOT/$dirname" ) {
		system "cd $ROOT/$dirname; make clean >/dev/null 2>&1";
		system "cd $ROOT/$dirname; cat .files 2>/dev/null|xargs rm -f 2>/dev/null";
		system "cd $ROOT/$dirname; cat .files 2>/dev/null|sort -r|xargs rmdir 2>/dev/null";
		system "rm -f $ROOT/$dirname/.files 2>/dev/null";
		system "rmdir $ROOT/$dirname/ 2>/dev/null";
	}
}

sub uninstall_shmem_apps();

sub install_shmem_apps($)
{
	my $srcdir=shift();

	my $file;

	# clean existing shmem sample applications
	uninstall_shmem_apps;

	# Copy all shmem sample applications
	check_dir("/usr/src/opa");
	check_dir("/usr/src/opa/shmem_apps");
	if ( -e "$srcdir/shmem/shmem_apps/shmem_apps.tgz" )
	{
		system("tar xfvz $srcdir/shmem/shmem_apps/shmem_apps.tgz --directory $ROOT/usr/src/opa/shmem_apps > $ROOT/usr/src/opa/shmem_apps/.files");
	}
	# allow all users to read the files so they can copy and use
	system("chmod -R ugo+r $ROOT/usr/src/opa/shmem_apps");
	system("find $ROOT/usr/src/opa/shmem_apps -type d|xargs chmod ugo+x");
}

sub uninstall_shmem_apps()
{
	# remove shmem_apps we installed or user compiled, however do not remove
	# any logs or other files the user may have created
	remove_shmem_apps "/usr/src/opa/shmem_apps";
	system "rmdir $ROOT/usr/src/opa 2>/dev/null";	# remove only if empty
	system "rmdir $ROOT/usr/lib/opa 2>/dev/null";	# remove only if empty
}

#!/usr/bin/perl
# BEGIN_ICS_COPYRIGHT8 ****************************************
# 
# Copyright (c) 2015, Intel Corporation
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# END_ICS_COPYRIGHT8   ****************************************

# [ICS VERSION STRING: @(#) ./comp.pl 10_4_1_0_1 [04/30/17 13:35]
use strict;
#use Term::ANSIColor;
#use Term::ANSIColor qw(:constants);
#use File::Basename;
#use Math::BigInt;

# ==========================================================================
# Fast Fabric Support tools for OFED (oftools) installation

# autostart functions are per subcomponent
sub start_oftools
{
}

sub stop_oftools
{
}

sub available_oftools
{
	my $srcdir=$ComponentInfo{'oftools'}{'SrcDir'};
	return (rpm_resolve("$srcdir/RPMS/*/", "any", "opa-basic-tools") ne "" );
}

sub installed_oftools
{
	return(system("rpm -q --quiet opa-basic-tools") == 0)
}

# only called if installed_oftools is true
sub installed_version_oftools
{
	if ( -e "$ROOT$BASE_DIR/version_ff" ) {
		return `cat $ROOT$BASE_DIR/version_ff`;
	} else {
		return "";
	}
}

# only called if available_oftools is true
sub media_version_oftools
{
	my $srcdir=$ComponentInfo{'oftools'}{'SrcDir'};
	return `cat "$srcdir/version"`;
}

sub build_oftools
{
	my $osver = $_[0];
	my $debug = $_[1];	# enable extra debug of build itself
	my $build_temp = $_[2];	# temp area for use by build
	my $force = $_[3];	# force a rebuild
	return 0;	# success
}

sub need_reinstall_oftools($$)
{
	my $install_list = shift();	# total that will be installed when done
	my $installing_list = shift();	# what items are being installed/reinstalled

	return "no";
}

sub preinstall_oftools
{
	my $install_list = $_[0];	# total that will be installed when done
	my $installing_list = $_[1];	# what items are being installed/reinstalled

	return 0;	# success
}

sub install_oftools
{
	my $install_list = $_[0];	# total that will be installed when done
	my $installing_list = $_[1];	# what items are being installed/reinstalled

	my $srcdir=$ComponentInfo{'oftools'}{'SrcDir'};

	my $version=media_version_oftools();
	chomp $version;
	printf("Installing $ComponentInfo{'oftools'}{'Name'} $version $DBG_FREE...\n");
	#LogPrint "Installing $ComponentInfo{'oftools'}{'Name'} $version $DBG_FREE for $CUR_OS_VER\n";
	LogPrint "Installing $ComponentInfo{'oftools'}{'Name'} $version $DBG_FREE for $CUR_DISTRO_VENDOR $CUR_VENDOR_VER\n";

	# Check $BASE_DIR directory ...exist 
	check_config_dirs();

	if ( -e "$srcdir/comp.pl" ) {
		check_dir("/usr/lib/opa");
		copy_systool_file("$srcdir/comp.pl", "/usr/lib/opa/.comp_oftools.pl");
	}
	check_dir("/usr/lib/opa/tools");
	check_dir("/usr/share/opa/samples");

	my $rpmfile = rpm_resolve("$srcdir/RPMS/*/", "any", "opa-basic-tools");
	rpm_run_install($rpmfile, "any", " -U ");

	$rpmfile = rpm_resolve("$srcdir/RPMS/*/", "any", "opa-address-resolution");
	rpm_run_install($rpmfile, "any", " -U ");
	check_rpm_config_file("/etc/rdma/dsap.conf");

	# we copy version file here for both fastfabric and oftools
	copy_data_file("$srcdir/version", "$BASE_DIR/version_ff");

	## Install OPA_SA_DB library, headers.
	check_dir("/usr/include/infiniband");
	copy_shlib("$srcdir/bin/$ARCH/$CUR_DISTRO_VENDOR.$CUR_VENDOR_VER/lib/$DBG_FREE/libopasadb", "$LIB_DIR/libopasadb", "1.0.0");

	$ComponentWasInstalled{'oftools'}=1;
}

sub postinstall_oftools
{
	my $install_list = $_[0];	# total that will be installed when done
	my $installing_list = $_[1];	# what items are being installed/reinstalled
}

sub uninstall_oftools
{
	my $install_list = $_[0];	# total that will be left installed when done
	my $uninstalling_list = $_[1];	# what items are being uninstalled

	NormalPrint("Uninstalling $ComponentInfo{'oftools'}{'Name'}...\n");

	rpm_uninstall_list("any", "verbose", ("opa-basic-tools", "opa-address-resolution") );

	# remove LSF and Moab related files
	system("rm -rf $ROOT/usr/lib/opa/LSF_scripts");
	system("rm -rf $ROOT/usr/lib/opa/Moab_scripts");

	# may be created by opaverifyhosts
	system("rm -rf $ROOT/usr/lib/opa/tools/nodescript.sh");
	system("rm -rf $ROOT/usr/lib/opa/tools/nodeverify.sh");

	system "rmdir $ROOT/usr/lib/opa/tools 2>/dev/null";	# remove only if empty

	# oftools is a prereq of fastfabric can cleanup shared files here
	system("rm -rf $ROOT$BASE_DIR/version_ff");
	system "rmdir $ROOT$BASE_DIR 2>/dev/null";	# remove only if empty
	system "rmdir $ROOT$OPA_CONFIG_DIR 2>/dev/null";	# remove only if empty
	system("rm -rf $ROOT/usr/lib/opa/.comp_oftools.pl");
	system "rmdir $ROOT/usr/lib/opa 2>/dev/null";	# remove only if empty
	$ComponentWasInstalled{'oftools'}=0;
}

sub check_os_prereqs_oftools
{
	return rpm_check_os_prereqs("oftools", "user");
}
#!/usr/bin/perl
# BEGIN_ICS_COPYRIGHT8 ****************************************
# 
# Copyright (c) 2015, Intel Corporation
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
#     * Redistributions of source code must retain the above copyright notice,
#       this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of Intel Corporation nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
# END_ICS_COPYRIGHT8   ****************************************

# [ICS VERSION STRING: @(#) ./comp.pl 10_4_1_0_1 [04/30/17 13:35]
use strict;
#use Term::ANSIColor;
#use Term::ANSIColor qw(:constants);
#use File::Basename;
#use Math::BigInt;

# ==========================================================================
# Fast Fabric installation

my $FF_CONF_FILE = "/usr/lib/opa/tools/opafastfabric.conf";
my $FF_TLS_CONF_FILE = "/etc/opa/opaff.xml";
sub available_fastfabric
{
	my $srcdir=$ComponentInfo{'fastfabric'}{'SrcDir'};
	return ((rpm_resolve("$srcdir/RPMS/*/", "any", "opa-basic-tools") ne "") &&
			(rpm_resolve("$srcdir/RPMS/*/", "any", "opa-fastfabric") ne ""));
}

sub installed_fastfabric
{
	return(system("rpm -q --quiet opa-fastfabric") == 0)
}

# only called if installed_fastfabric is true
sub installed_version_fastfabric
{
	my $version_file="$BASE_DIR/version_ff";

	if ( -e "$version_file" ) {
		return `cat $ROOT$version_file`;
	} else {
		return "";
	}
}

# only called if available_fastfabric is true
sub media_version_fastfabric
{
	my $srcdir=$ComponentInfo{'fastfabric'}{'SrcDir'};
	return `cat "$srcdir/version"`;
}

sub build_fastfabric
{
	my $osver = $_[0];
	my $debug = $_[1];	# enable extra debug of build itself
	my $build_temp = $_[2];	# temp area for use by build
	my $force = $_[3];	# force a rebuild
	return 0;	# success
}

sub need_reinstall_fastfabric($$)
{
	my $install_list = shift();	# total that will be installed when done
	my $installing_list = shift();	# what items are being installed/reinstalled

	return "no";
}

sub check_os_prereqs_fastfabric
{	
	return rpm_check_os_prereqs("fastfabric", "user");
}

sub preinstall_fastfabric
{
	my $install_list = $_[0];	# total that will be installed when done
	my $installing_list = $_[1];	# what items are being installed/reinstalled

	return 0;	# success
}

sub install_fastfabric
{
	my $install_list = $_[0];	# total that will be installed when done
	my $installing_list = $_[1];	# what items are being installed/reinstalled

	my $srcdir=$ComponentInfo{'fastfabric'}{'SrcDir'};
	my $depricated_dir = "/etc/sysconfig/opa";

	my $version=media_version_fastfabric();
	chomp $version;
	printf("Installing $ComponentInfo{'fastfabric'}{'Name'} $version $DBG_FREE...\n");
		LogPrint "Installing $ComponentInfo{'fastfabric'}{'Name'} $version $DBG_FREE for $CUR_DISTRO_VENDOR $CUR_VENDOR_VER\n";
	check_config_dirs();
	if ( -e "$srcdir/comp.pl" ) {
		check_dir("/usr/lib/opa");
		copy_systool_file("$srcdir/comp.pl", "/usr/lib/opa/.comp_fastfabric.pl");
	}

	my $rpmfile = rpm_resolve("$srcdir/RPMS/*/", "any", "opa-fastfabric");
	rpm_run_install($rpmfile, "any", " -U ");

	check_dir("/usr/lib/opa/tools");
	check_dir("/usr/share/opa/samples");
	system "chmod ug+x $ROOT/usr/share/opa/samples/hostverify.sh";
	system "rm -f $ROOT/usr/share/opa/samples/nodeverify.sh";

	check_rpm_config_file("$FF_TLS_CONF_FILE");
	printf("Default opaff.xml can be found in '/usr/share/opa/samples/opaff.xml-sample'\n");
	check_rpm_config_file("$CONFIG_DIR/opa/opamon.conf", $depricated_dir);
	check_rpm_config_file("$CONFIG_DIR/opa/opafastfabric.conf", $depricated_dir);
	check_rpm_config_file("$CONFIG_DIR/opa/allhosts", $depricated_dir);
	check_rpm_config_file("$CONFIG_DIR/opa/chassis", $depricated_dir);
	check_rpm_config_file("$CONFIG_DIR/opa/hosts", $depricated_dir);
	check_rpm_config_file("$CONFIG_DIR/opa/ports", $depricated_dir);
	check_rpm_config_file("$CONFIG_DIR/opa/switches", $depricated_dir);
	check_rpm_config_file("/usr/lib/opa/tools/osid_wrapper");

	#install_conf_file("$ComponentInfo{'fastfabric'}{'Name'}", "$FF_TLS_CONF_FILE", "$srcdir/fastfabric/tools/tls");
	#remove_conf_file("$ComponentInfo{'fastfabric'}{'Name'}", "$OPA_CONFIG_DIR/iba_stat.conf");
	system("rm -rf $ROOT$OPA_CONFIG_DIR/iba_stat.conf");	# old config

	install_shmem_apps($srcdir);

	$rpmfile = rpm_resolve("$srcdir/RPMS/*/", "any", "opa-mpi-apps");
	rpm_run_install($rpmfile, "any", " -U ");



	$ComponentWasInstalled{'fastfabric'}=1;
}

sub postinstall_fastfabric
{
	my $install_list = $_[0];	# total that will be installed when done
	my $installing_list = $_[1];	# what items are being installed/reinstalled
}

sub uninstall_fastfabric
{
	my $install_list = $_[0];	# total that will be left installed when done
	my $uninstalling_list = $_[1];	# what items are being uninstalled


	rpm_uninstall_list("any", "verbose", ("opa-mpi-apps", "opa-fastfabric") );

	NormalPrint("Uninstalling $ComponentInfo{'fastfabric'}{'Name'}...\n");
	remove_conf_file("$ComponentInfo{'fastfabric'}{'Name'}", "$FF_CONF_FILE");
	remove_conf_file("$ComponentInfo{'fastfabric'}{'Name'}", "$OPA_CONFIG_DIR/iba_stat.conf");
	remove_conf_file("$ComponentInfo{'fastfabric'}{'Name'}", "$FF_TLS_CONF_FILE");
	

	uninstall_shmem_apps;

	# remove samples we installed (or user compiled), however do not remove
	# any logs or other files the user may have created
	remove_installed_files "/usr/share/opa/samples";
	system "rmdir $ROOT/usr/share/opa/samples 2>/dev/null";	# remove only if empty

	system("rm -rf $ROOT/usr/lib/opa/.comp_fastfabric.pl");
	system "rmdir $ROOT/usr/lib/opa 2>/dev/null";	# remove only if empty
	system "rmdir $ROOT$BASE_DIR 2>/dev/null";	# remove only if empty
	system "rmdir $ROOT$OPA_CONFIG_DIR 2>/dev/null";	# remove only if empty
	$ComponentWasInstalled{'fastfabric'}=0;
}

