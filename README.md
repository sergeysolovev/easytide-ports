# easytide-ports
A few bash and node.js scripts for retrieving and geocoding ports from [Admiralty EasyTide](http://www.ukho.gov.uk/easytide/EasyTide/Index.aspx) of United Kingdom Hydrographic Office. A port identifier can be used to access a corresponding tide chart by url.

## Example
The following link shows tide chart for the port with id 5382 "Benoa, Bali":
```
http://www.ukho.gov.uk/easytide/EasyTide/ShowPrediction.aspx?PredictionLength=1&PortID=5382
```

## getports.sh
Retrieves info about ports: identifier (ukhoId), name (ukhoName) and location name (ukhoLocation).

### Approach
The ukho website is stateful by the means of ASP.NET View State. Hence we need to maintain it's value from request to request. We start from searching by "**" expression and setting up the initial value of viewstate, then procceed to each page of search results.

## Users
- [Bali surf forecast](https://play.google.com/store/apps/details?id=com.avaa.surfforecast)
- [Bali tide + chart widget](https://play.google.com/store/apps/details?id=com.avaa.balitidewidget)

## Update
<http://www.ukho.gov.uk> is closing, though [Admiralty EasyTide](http://www.ukho.gov.uk/easytide/EasyTide/Index.aspx) is still available.