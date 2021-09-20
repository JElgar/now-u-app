For v2 explore we will need the api to be like the following:

## Endpoints

GET /actions 

- Field for completed -> whether the user making the request has completed the action. If user is logged out then false.
- Add nested causes

```json
[
  {
      "id": 47,
      "title": "Watch 'Why talk toilets?'",
      "type": "learn",
      "causes": [
        {
          "id": 1,
          "title": "Name of the campaign",
          "icon": "ic-abc"
        }
      ],
      "time": 2.0,
      "end_date": null
      "created_at": "2020-07-06T20:49:43.892Z",
      "release_date": "2020-07-06T20:51:26.708Z",
      "enabled": true,
      "completed": true
    }
]
```

GET /actions/1

```json
{
  "id": 1,
  "title": "Watch 'Why talk toilets?'",
  "link": "https://www.youtube.com/watch?v=MS4va1WLaro&list=PLc-oawSTlDS1PfrZZVSRDs4s1nPcVeaEM&index=8",
  "type": "learn",
  "causes": [
    {
      "id": 1,
      "title": "Name of the campaign",
      "icon": "ic-abc"
    }
  ],
  "created_at": "2020-07-06T20:49:43.892Z",
  "updated_at": "2020-07-06T20:51:26.708Z",
  "what_description": "Watch this short WaterAid video to find out more about access to decent toilets and the impacts of poor sanitation facilities.",
  "why_description": "Access to decent sanitation facilties is essential for almost every aspect of life. By learning more about the issue we will be in a stronger position to advocate for universal access to WASH and to take effective action.",
  "time": 2.0,
  "enabled": true,
  "release_date": null,
  "end_date": null,
  "completed": true
}
```

GET /campaigns

- completed -> true if all actions in the campaign are completed. false otherwise. false if auth token not provided (no user)

```json
{
  "id": 3,
  "causes": [
    {
      "id": 1,
      "title": "Name of the campaign",
      "icon": "ic-abc"
    }
  ],
  "title": "Global access to water, sanitation & hygiene",
  "header_image": "https://images.unsplash.com/photo-1437914983566-976d85602771?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
  "icon": "ic-abc",
  "created_at": "2020-06-07T00:54:00.000Z",
  "updated_at": "2021-08-06T23:04:26.401Z",
  "enabled": true,
  "start_date": "2021-08-06T23:00:00.000Z",
  "end_date": "2021-09-17T23:00:00.000Z",
  "short_name": "WASH",
  "completed": true
}
```

GET /campaigns/1

```json
{
  "id": 1,
  "causes": [
    {
      "id": 1,
      "title": "Name of the campaign",
      "icon": "ic-abc"
    }
  ],
  "title": "Global access to water, sanitation & hygiene",
  "description_app": "Some descirption for the app",
  "header_image": "https://images.unsplash.com/photo-1437914983566-976d85602771?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1050&q=80",
  "created_at": "2020-06-07T00:54:00.000Z",
  "updated_at": "2021-08-06T23:04:26.401Z",
  "video_link": "https://www.youtube.com/watch?v=y1QW-xxrbsI",
  "description_web": "Some description for the website",
  "enabled": true,
  "start_date": "2021-08-06T23:00:00.000Z",
  "end_date": "2021-09-17T23:00:00.000Z",
  "short_name": "WASH",
  "number_of_campaigners": 146,
  "number_of_completed_actions": 131,
  "general_partners": [
    {
      "id": 1,
      "name": "Just a Drop",
      "logo_link": "https://watertogo.eu/wp-content/uploads/2018/04/just-a-drop-jad-logo.jpg"
    }
  ],
  "campaign_partners": [
    {
      "id": 1,
      "name": "Just a Drop",
      "logo_link": "https://watertogo.eu/wp-content/uploads/2018/04/just-a-drop-jad-logo.jpg"
    }
  ],
  "key_aims": [
    {
      "id": 31,
      "title": "Raise awareness of WASH issues and their heightened importance during the pandemic",
      "type": "Key Aim",
      "created_at": "2020-06-28T20:07:36.627Z",
      "updated_at": "2020-06-28T20:07:36.627Z"
    }
  ],
  "actions": [
    3 actions serialized in the same way as /actions
  ],
  "infographic_url": "https://now-u.s3.eu-west-2.amazonaws.com/WASH_campaign_9630b3c467.png",
  "completed": true
}
```

/causes

- Selected is true if the user has 'joined' the cause

```json
  [
    {
      "id": 1,
      "title": "Name of the campaign",
      "icon": "ic-abc",
      "description": "Cause description",
      "selected": true
    }
  ]
```


## Filters

/actions /campaigns should have causes filter:

e.g.
`/actions?cause__in=[1,2]` should only reutrn actions which are in cause 1 and/or in cause 2


/actions /campaigns should have recommened and of the month filter:

- Recommended, Of the month -> These both require extra booleans on the models

e.g.
`/actions?of_the_month=true` should only return actions which are actions of the month
`/actions?recommended=true` should only reutrn actions which are recommended

/actions /campaigns should provide completed endpoints

`/actions?completed=true` should only return actions which are completed 

## Limit

All endpoints should provide a limit

e.g.
`/actions?limit=5` should return a max of 5 actions
