#!/bin/bash

readonly SELECT_PORT_URL='http://www.ukho.gov.uk/easytide/EasyTide/SelectPort.aspx'
currentPage=$(mktemp) || exit 1

# initial page
curl -o $currentPage -s -S -H 'Cookie: EasyTideLastSearchType=Search; EasyTideLastTextSearch=**' $SELECT_PORT_URL > /dev/null

viewstate=$(perl -nle 'print $& if m{id="__VIEWSTATE" value="\K[^"]+}' \
  $currentPage)
eventvalidation=$(perl -nle 'print $& if m{id="__EVENTVALIDATION" value="\K[^"]+}' \
  $currentPage)

# search page
curl -s -S -o $currentPage 'http://www.ukho.gov.uk/easytide/EasyTide/SelectPort.aspx' \
  --data-urlencode "__VIEWSTATE=$viewstate" \
  --data-urlencode "__EVENTVALIDATION=$eventvalidation" \
  --data "PortSelectionSearch%3AtxtSearch=**&PortSelectionSearch%3AbutSearch%3A_ctl0.x=75&PortSelectionSearch%3AbutSearch%3A_ctl0.y=15" \
  --compressed >/dev/null

viewstate=$(perl -nle 'print $& if m{id="__VIEWSTATE" value="\K[^"]+}' \
  $currentPage)
eventvalidation=$(perl -nle 'print $& if m{id="__EVENTVALIDATION" value="\K[^"]+}' \
  $currentPage)

# navigate by pages:
for pageNumber in `seq 1 182`;
do
  eventtarget=PSL'$'dlPager'$'_ctl$pageNumber'$'Linkbutton7
  echo "processing page: $pageNumber of 182"

  # current page within pager:
  curl -s -S -o $currentPage 'http://www.ukho.gov.uk/easytide/EasyTide/SelectPort.aspx' \
    --data-urlencode "__EVENTTARGET=$eventtarget" \
    --data-urlencode "__VIEWSTATE=$viewstate" \
    --data-urlencode "__EVENTVALIDATION=$eventvalidation" \
    --data "PortSelectionSearch%3AtxtSearch=**" \
    --compressed >/dev/null

  viewstate=$(perl -nle 'print $& if m{id="__VIEWSTATE" value="\K[^"]+}' \
    $currentPage)
  eventvalidation=$(perl -nle 'print $& if m{id="__EVENTVALIDATION" value="\K[^"]+}' \
    $currentPage)

  perl -0ne 'while(m/<a id="PSL_dl__[^"]+"[^\(]*\(\047([^\047]+)\047[^>]+>([^<]+)<\/a>\s*&nbsp;-&nbsp;([^\x0a\x0d]+)/g){print "$1\t$2\t$3\n"}' $currentPage > 'tab.txt'

  while IFS=$'\t' read eventtarget name location; do
    curl -v -s -S 'http://www.ukho.gov.uk/easytide/EasyTide/SelectPort.aspx' \
      --data-urlencode "__EVENTTARGET=$eventtarget" \
      --data-urlencode "__VIEWSTATE=$viewstate" \
      --data-urlencode "__EVENTVALIDATION=$eventvalidation" \
      --data "PortSelectionSearch%3AtxtSearch=**" \
      --compressed 2>outputFile>/dev/null
    portId=$(perl -nle 'print $& if m{PortID=\K[^\r\n]+}' outputFile)
    echo "${portId} :: ${name} :: ${location}"
    echo -e "${portId}\t${name}\t${location}" >> 'ports.txt'
  done < 'tab.txt';
done

# remove tmp files
rm -f $currentPage
rm -f 'tab.txt'
rm -f 'outputFile'
