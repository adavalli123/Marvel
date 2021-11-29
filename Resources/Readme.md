# Marvel
Created an iOS application on Marvel Characters.

# Environment
- Xcode 13
- Swift 5 above
- Cocapods 
    - Firestore

# Steps
- Create an Marvel account (url - https://marvel.com)
- Upon signup, you will get an email, confirm it
- Set public and private key (for more info - https://developer.marvel.com/account)
- Sample url response you will find here (url - https://developer.marvel.com/docs) fill the timestamp, publickey, md5 encrpted code
- run the xcode the project

# Todo's
- [x] Online/Offline network calls
- [x] Local persistance
- [x] Search
- [x] infinite scroll
- [x] textview link to browser
- [x] unit tests - Added one file - https://github.com/adavalli123/Marvel/blob/main/MarvelTests/List/ListViewModelTests.swift
- [ ] used combine/ react native
- [ ] need to improve image experience
- [ ] clean logs/system logs

# Demos
#### Json - Response
```
{
    "code": 200,
    "status": "Ok",
    "copyright": "© 2021 MARVEL",
    "attributionText": "Data provided by Marvel. © 2021 MARVEL",
    "attributionHTML": "<a href=\"http://marvel.com\">Data provided by Marvel. © 2021 MARVEL</a>",
    "etag": "80f5e7fb141d52dd02568e5ae90823cdc43e2793",
    "data": {
        "offset": 0,
        "limit": 1,
        "total": 1559,
        "count": 1,
        "results": [{
            "id": 1011334,
            "name": "3-D Man",
            "description": "",
            "modified": "2014-04-29T14:18:17-0400",
            "thumbnail": {
                "path": "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784",
                "extension": "jpg"
            },
            "resourceURI": "http://gateway.marvel.com/v1/public/characters/1011334",
            "comics": {
                "available": 12,
                "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011334/comics",
                "items": [{
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/21366",
                    "name": "Avengers: The Initiative (2007) #14"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/24571",
                    "name": "Avengers: The Initiative (2007) #14 (SPOTLIGHT VARIANT)"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/21546",
                    "name": "Avengers: The Initiative (2007) #15"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/21741",
                    "name": "Avengers: The Initiative (2007) #16"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/21975",
                    "name": "Avengers: The Initiative (2007) #17"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/22299",
                    "name": "Avengers: The Initiative (2007) #18"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/22300",
                    "name": "Avengers: The Initiative (2007) #18 (ZOMBIE VARIANT)"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/22506",
                    "name": "Avengers: The Initiative (2007) #19"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/8500",
                    "name": "Deadpool (1997) #44"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/10223",
                    "name": "Marvel Premiere (1972) #35"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/10224",
                    "name": "Marvel Premiere (1972) #36"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/comics/10225",
                    "name": "Marvel Premiere (1972) #37"
                }],
                "returned": 12
            },
            "series": {
                "available": 3,
                "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011334/series",
                "items": [{
                    "resourceURI": "http://gateway.marvel.com/v1/public/series/1945",
                    "name": "Avengers: The Initiative (2007 - 2010)"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/series/2005",
                    "name": "Deadpool (1997 - 2002)"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/series/2045",
                    "name": "Marvel Premiere (1972 - 1981)"
                }],
                "returned": 3
            },
            "stories": {
                "available": 21,
                "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011334/stories",
                "items": [{
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/19947",
                    "name": "Cover #19947",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/19948",
                    "name": "The 3-D Man!",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/19949",
                    "name": "Cover #19949",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/19950",
                    "name": "The Devil's Music!",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/19951",
                    "name": "Cover #19951",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/19952",
                    "name": "Code-Name:  The Cold Warrior!",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/47184",
                    "name": "AVENGERS: THE INITIATIVE (2007) #14",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/47185",
                    "name": "Avengers: The Initiative (2007) #14 - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/47498",
                    "name": "AVENGERS: THE INITIATIVE (2007) #15",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/47499",
                    "name": "Avengers: The Initiative (2007) #15 - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/47792",
                    "name": "AVENGERS: THE INITIATIVE (2007) #16",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/47793",
                    "name": "Avengers: The Initiative (2007) #16 - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/48361",
                    "name": "AVENGERS: THE INITIATIVE (2007) #17",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/48362",
                    "name": "Avengers: The Initiative (2007) #17 - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/49103",
                    "name": "AVENGERS: THE INITIATIVE (2007) #18",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/49104",
                    "name": "Avengers: The Initiative (2007) #18 - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/49106",
                    "name": "Avengers: The Initiative (2007) #18, Zombie Variant - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/49888",
                    "name": "AVENGERS: THE INITIATIVE (2007) #19",
                    "type": "cover"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/49889",
                    "name": "Avengers: The Initiative (2007) #19 - Int",
                    "type": "interiorStory"
                }, {
                    "resourceURI": "http://gateway.marvel.com/v1/public/stories/54371",
                    "name": "Avengers: The Initiative (2007) #14, Spotlight Variant - Int",
                    "type": "interiorStory"
                }],
                "returned": 20
            },
            "events": {
                "available": 1,
                "collectionURI": "http://gateway.marvel.com/v1/public/characters/1011334/events",
                "items": [{
                    "resourceURI": "http://gateway.marvel.com/v1/public/events/269",
                    "name": "Secret Invasion"
                }],
                "returned": 1
            },
            "urls": [{
                "type": "detail",
                "url": "http://marvel.com/comics/characters/1011334/3-d_man?utm_campaign=apiRef&utm_source=e5e56b34797627c785aeda89df54b247"
            }, {
                "type": "wiki",
                "url": "http://marvel.com/universe/3-D_Man_(Chandler)?utm_campaign=apiRef&utm_source=e5e56b34797627c785aeda89df54b247"
            }, {
                "type": "comiclink",
                "url": "http://marvel.com/comics/characters/1011334/3-d_man?utm_campaign=apiRef&utm_source=e5e56b34797627c785aeda89df54b247"
            }]
        }]
    }
}
```

#### Request
```
URL:    https://gateway.marvel.com/v1/public/characters?ts=659341676.789555&apikey=e5e56b34797627c785aeda89df54b247&hash=891aa0cad8e0ae9f20fd3780deb59468&limit=1&offset=0
ts    659341676.789555
apikey    e5e56b34797627c785aeda89df54b247
hash    891aa0cad8e0ae9f20fd3780deb59468
limit    1
offset    0

```

#### Videos

