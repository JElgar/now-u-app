import 'package:app/services/api.dart';

import 'package:app/models/Campaign.dart';
import 'package:app/models/Campaigns.dart';
import 'package:app/models/Action.dart';
import 'package:app/models/Article.dart';
import 'package:app/models/FAQ.dart';
import 'package:app/models/Organisation.dart';
import 'package:app/models/Learning.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'package:http/http.dart' as http;
import 'dart:convert';

class JsonApi implements Api {

  final String domainPrefix = "https://now-u-api.herokuapp.com/api/v1/";
  //final String domainPrefix = "https://api.now-u.com/api/v1/";

  void toggleStagingApi() {}

  @override
  Future<Campaign> getCampaign(int id) async {
    var response = await http.get(domainPrefix + "campaigns/1");
    if (response.statusCode == 200) {
      print("We got a 200!");
      Campaign c = Campaign.fromJson(json.decode(response.body)['data']);
      print("Here is the campaign");
      print(c);
      return c;
    }
    else {
      print("We got an error whilst doing the http request");
      return Future.error("Error getting campaign in http api", StackTrace.fromString("The stack trace is"));
    }
  }

  @override
  Future<Campaigns> getCampaigns() async {
    print("Getting campaigns");
    print("ITS HAPPENING");
    var response = await http.get(domainPrefix + "campaigns");
    if (response.statusCode == 200) {
      print("200");
      Campaigns cs = Campaigns.fromJson(json.decode(response.body)['data']);
      print("We got some camps");
      return cs;
    }
    else {
      // TODO different error different reults
      print("We got an error whilst doing the http request");
      return Future.error("Error getting campaigns in http api", StackTrace.fromString("The stack trace is"));
    }
  }
  
  Future<Campaigns> getAllCampaigns() async {
    print("Getting campaigns");
    print("ITS HAPPENING");
    var response = await http.get(domainPrefix + "campaigns");
    if (response.statusCode == 200) {
      print("200");
      Campaigns cs = Campaigns.fromJson(json.decode(response.body)['data']);
      print("We got some camps");
      return cs;
    }
    else {
      // TODO different error different reults
      print("We got an error whilst doing the http request");
      return Future.error("Error getting campaigns in http api", StackTrace.fromString("The stack trace is"));
    }
  }
  
  @override
  Future<CampaignAction> getAction(int id) async {
    print("Getting action");
    var response = await http.get(domainPrefix + "actions/${id}");
    if (response.statusCode == 200) {
      print("200");
      CampaignAction a = CampaignAction.fromJson(json.decode(response.body)['data']);
      print("We got an action");
      return a;
    }
    else {
      // TODO different error different reults
      print("We got an error whilst doing the http request");
      return Future.error("Error getting campaigns in http api", StackTrace.fromString("The stack trace is"));
    }
  }
  
  //@override
  //Future<Campaigns> getCampaigns() async {
  //  String data = await rootBundle.loadString('assets/json/campaigns.json');
  //  print("got campaigns data");
  //  Campaigns cs = Campaigns.fromJson(json.decode(data));
  //  print("We got some camps");
  //  print(cs.getActiveCampaigns()[0].getTitle());
  //  print(cs.getActiveCampaigns()[1].getTitle());
  //  print(cs.getActiveCampaigns()[2].getTitle());
  //  return cs;
  //}

  @override
  Future<List<Article>> getArticles() async {
    String data = await rootBundle.loadString('assets/json/articles.json');
    List<Article> c = json.decode(data).map((e) => Article.fromJson(e)).toList().cast<Article>();
    return c;
  }

  @override
  Future<Article> getVideoOfTheDay() async {
    String data = await rootBundle.loadString('assets/json/articles.json');
    Article a = Article.fromJson((json.decode(data) as List)[0]);
    return a; 
  }
  
  @override
  Future<List<FAQ>> getFAQs() async {
    var response = await http.get(domainPrefix + "faqs");
    if (response.statusCode == 200) {
      print("We got a 200 when getting faqs!");
      List<FAQ> faqs = json.decode(response.body)['data'].map((e) => FAQ.fromJson(e)).toList().cast<FAQ>();
      print("Here is the faqs");
      print(faqs);
      return faqs;
    }
    else {
      print("We got an error whilst doing the http request");
      return Future.error("Error getting faqs in http api", StackTrace.fromString("The stack trace is"));
    }
  }
  
  @override
  Future<List<Organisation>> getPartners() async {
    String data = await rootBundle.loadString('assets/json/organisations.json');
    List<Organisation> c = json.decode(data).map((e) => Organisation.fromJson(e)).toList().cast<Organisation>();
    return c;
  }
  
  @override
  Future<LearningCentre> getLearningCentre(int campaignId) async {
    String data = await rootBundle.loadString('assets/json/learningCentre.json');
    LearningCentre c = LearningCentre.fromJson(json.decode(data));
    return c;
  }
} 
