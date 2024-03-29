import {HttpClient} from 'aurelia-http-client';
import {inject} from 'aurelia-framework';

export class DataContext {
  datastore;
  static inject = [HttpClient, Datastore];
  constructor(http, datastore) {
    this.http = http.configure(x => {
      x.withHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content)
    });
    this.datastore = datastore;
  }
  load() {
    this.getAvailabilities();
    this.getExperienceLevels();
  }
  getAvailabilities() {
    this.http.get('/availabilities.json').then(result => {
      result.content.forEach(availability => {
        this.datastore.availabilities.push(availability);
      });
    });
  }
  getExperienceLevels() {
    this.http.get('/experience_levels.json').then(result => {
      result.content.forEach(experienceLevel => {
        this.datastore.experienceLevels.push(experienceLevel);
      });
    });
  }
  getNewsItems(){
    return client.get('/news_items.json')
  }
  likeCard(card){
    return client.createRequest('/news_items/like.json')
      .asPost()
      .withHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content)
      .withHeader('Content-Type', 'application/json')
      .withContent(card)
      .send();
  }
}
