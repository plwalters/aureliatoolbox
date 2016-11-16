import {Session} from 'services/session';
import {User} from 'models/index';
import {TemplatingEngine} from 'aurelia-framework';
import {HttpClient} from 'aurelia-http-client';

export class UsersService {
  static inject  = [Session, TemplatingEngine, HttpClient];
  constructor(session, templatingEngine, httpClient) {
    this.session = session;
    this.http = httpClient.configure(x => {
      x.withHeader('X-CSRF-Token', document.querySelector('meta[name="csrf-token"]').content)
    });;
    let dropdown = document.querySelector('user-dropdown');
    let otherDeadContent = document.querySelector('user-dropdown + li');
    if (dropdown) {
      templatingEngine.enhance(dropdown);
      otherDeadContent.style.display = 'none';
    }
  }
  getAll() {
    let url = `/admin/users.json`;
    return this.http.get(url).then(result => {
      let users = [];
      result.content.forEach(user => {
        users.push(new User(user));
      });
      return users;
    });
  }
  save(user) {
    let url = `/admin/users/${user.id}`;
    return this.http.put(url, user).then(result => {
      console.log('Saved');
    });
  }
}