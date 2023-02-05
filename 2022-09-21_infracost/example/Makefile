breakdown-json:
	infracost breakdown --path . \
		--format json \
		--out-file infracost.local.out.json

breakdown-table:
	infracost output --path infracost.local.out.json \
		--format table

breakdown-html:
	infracost output --path infracost.local.out.json \
  --format html --out-file infracost.local.out.html

get-master:
	curl -Lo infracost.master.out.json \
		https://gitlab.sikademo.com/ondrejsika/example/-/jobs/artifacts/master/raw/infracost.local.out.json?job=infracost

diff-json:
	infracost diff --path infracost.local.out.json \
		--compare-to infracost.master.out.json \
		--format json \
		--out-file infracost.diff.out.json

diff-table:
	infracost diff --path infracost.local.out.json \
		--compare-to infracost.master.out.json

gitlab-comment-commit:
	infracost comment gitlab \
		--gitlab-server-url https://gitlab.sikademo.com \
		--gitlab-token=7tMNgSABZLrgBLE8J7_2 \
		--path=infracost.diff.out.json \
		--repo ondrejsika/example \
		--commit ${CI_COMMIT_SHA}

gitlab-comment-merge-request:
	infracost comment gitlab \
		--gitlab-server-url https://gitlab.sikademo.com \
		--gitlab-token=7tMNgSABZLrgBLE8J7_2 \
		--path=infracost.diff.out.json \
		--repo ondrejsika/example \
		--merge-request ${CI_MERGE_REQUEST_ID}
