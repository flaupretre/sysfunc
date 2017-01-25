#
# Pulp-related software (http://pulpproject.org/)
#
#============================================================================

#=============================================================================
# Section: Pulp
#=============================================================================

##------------------------------------------------
# Remove RPM package(s)
#
# Args:
#	$1: Repo name (repo-id)
#	$2-*: RPM package(s) to remove
# Returns: 0 if OK. !=0 if not
# Displays: Pulp info messages
#------------------------------------------------

function sf_pulp_rpm_remove
{
typeset repo pkgs pkg ret

ret=0

repo="$1"
[ "X$repo" = X ] && sf_fatal "No repo specified" && return 1
shift
pkgs="$*"
[ -z "$pkgs" ] && sf_fatal "No package specified" && return 1

#---

for pkg in $pkgs ; do
	pulp-admin rpm repo remove rpm --repo-id $repo --str-eq "filename=$pkg" || ret=1
done

return $ret
}

##------------------------------------------------
# Publish a RPM repo
#
# Args:
#	$1: Repo name (repo-id)
# Returns: 0 if OK. !=0 if not
# Displays: Pulp info messages
#------------------------------------------------

function sf_pulp_rpm_publish
{
typeset repo

repo="$1"
[ "X$repo" = X ] && sf_fatal "No repo specified" && return 1

#---

pulp-admin rpm repo publish run --repo-id $repo
}

##------------------------------------------------
# Upload RPM package(s)
#
# Args:
#	$1: Repo name (repo-id)
#	$2-*: RPM packages
# Returns: 0 if OK. !=0 if not
# Displays: Pulp info messages
#------------------------------------------------

function sf_pulp_rpm_upload
{
typeset repo pkgs pkg ret

ret=0

repo="$1"
[ "X$repo" = X ] && sf_fatal "No repo specified" && return 1
shift
pkgs="$*"
[ -z "$pkgs" ] && sf_fatal "No package specified" && return 1

#---

for pkg in $pkgs ; do
	#-- First, remove package if it is already existing in the repo
	#-- Known bug (see https://bugzilla.redhat.com/show_bug.cgi?id=1041317)

	sf_pulp_rpm_remove $repo $pkg || :

	#-- Upload

	pulp-admin rpm repo uploads rpm --file "$pkg" --repo-id  "$repo" || ret=1
done

# Auto-publish does not seem to work...

sf_pulp_rpm_publish $repo

return $ret
}

#=============================================================================
