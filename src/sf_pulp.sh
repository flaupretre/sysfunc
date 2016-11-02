#
# Pulp-related software (http://pulpproject.org/)
#
#============================================================================

#=============================================================================
# Section: Pulp
#=============================================================================

##------------------------------------------------
# Remove a RPM package
#
# Args:
#	$1: Repo name (repo-id)
#	$2: RPM package
# Returns: 0 if OK. !=0 if not
# Displays: Pulp info messages
#------------------------------------------------

function sf_pulp_rpm_remove
{
typeset repo pkg

repo="$1"
[ "X$repo" = X ] && sf_fatal "No repo specified" && return 1
pkg="$2"
[ -z "$pkg" ] && sf_fatal "Empty package name" && return 1

#---

pulp-admin rpm repo remove rpm --repo-id $repo --str-eq "filename=$pkg"
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
# Upload a RPM package
#
# Args:
#	$1: Repo name (repo-id)
#	$2: RPM package
# Returns: 0 if OK. !=0 if not
# Displays: Pulp info messages
#------------------------------------------------

function sf_pulp_rpm_upload
{
typeset repo pkg

repo="$1"
[ "X$repo" = X ] && sf_fatal "No repo specified" && return 1
pkg="$2"
[ ! -f "$pkg" ] && sf_fatal "$pkg: File not found" && return 1

#---

#-- First, remove package if it is already existing in the repo
#-- Known bug (see https://bugzilla.redhat.com/show_bug.cgi?id=1041317)

sf_pulp_rpm_remove $repo $pkg || :

#-- Upload

pulp-admin rpm repo uploads rpm --file "$pkg" --repo-id  "$repo" || return 1

# Auto-publish does not seem to work...

sf_pulp_rpm_publish $repo
}

#=============================================================================
