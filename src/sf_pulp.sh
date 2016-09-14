#
# Pulp-related software (http://pulpproject.org/)
#
#============================================================================

#=============================================================================
# Section: Pulp
#=============================================================================

##------------------------------------------------
# Upload an RPM package
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

pulp-admin rpm repo remove rpm --repo-id $repo --str-eq "filename=$pkg" || :

#-- Upload

pulp-admin rpm repo uploads rpm --file "$pkg" --repo-id  "$repo"

# Auto-publish does not seem to work...

pulp-admin rpm repo publish run --repo-id $repo
}

#=============================================================================
