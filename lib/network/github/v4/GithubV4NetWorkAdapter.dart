import 'dart:collection';

import 'package:gitbbs/constant/GitConstant.dart';
import 'package:gitbbs/model/cachemanager/git_gist_cache_manager.dart';
import 'package:gitbbs/network/IssueState.dart';
import 'package:gitbbs/network/Request.dart';
import 'package:gitbbs/network/github/model/github_gist_file.dart';
import 'package:gitbbs/network/github/v4/V4Request.dart';
import 'package:gitbbs/network/github/v4/v4_pre_view_request.dart';
import 'package:gitbbs/network/github/v4/v4_query.dart';
import '../../GitNetworkRequestAdapter.dart';

class GithubV4NetWorkAdapter extends GitNetworkRequestAdapter {
  @override
  String getApiUrl() => 'https://api.github.com';

  @override
  Request getMoreIssues(List<String> label, String creator,
      IssueState issueState, String before, String after, int size) {
    String query = getIssuesQuery(issueState, size,
        label: label, creator: creator, before: before, after: after);
    var map = {'query': query};
    return V4Request(map);
  }

  @override
  Request createIssue(String title, String body, String label) {
    var path = "/repos/$owner/$repoName/issues";
    var map = Map<String, dynamic>();
    map['title'] = title;
    map['body'] = body;
    map['labels'] = [label];
    return Request(path, map, Method.POST);
  }

  @override
  Request getIssue(int number) {
    String query = getIssueQuery(number);
    var map = {'query': query};
    return V4Request(map);
  }

  @override
  Request getComments(int number, String before, int size) {
    String query = getCommentsQuery(number, before, size);
    var map = {'query': query};
    return V4Request(map);
  }

  @override
  Request addComment(String issueId, String body) {
    String query = getAddCommentQuery(issueId, body);
    var map = {'query': query};
    return V4Request(map);
  }

  @override
  Request doAuthenticated(String token, String username) {
    String query = getUserQuery(username);
    var map = {'query': query};
    return V4Request(map, header: {"Authorization": 'token $token'});
  }

  @override
  Request modifyComment(String commentId, String body) {
    String query = getModifyCommentQuery(commentId, body);
    var map = {'query': query};
    return V4PreViewRequest(map);
  }

  @override
  Request deleteComment(String commentId) {
    String query = getDeleteCommentQuery(commentId);
    var map = {'query': query};
    return V4PreViewRequest(map);
  }

  @override
  Request getGists(String login) {
    String query = getGistsQuery(login);
    var map = {'query': query};
    return V4Request(map);
  }

  @override
  Request forkConfigGist() {
    return Request('/gists/$GITS_CONFIG_ID/forks', {}, Method.POST);
  }

  Request saveConfigGist(Map<String, GithubGistFile> map) {
    return Request(
        '/gists/${GitGistCacheManager.configId}',
        {
          'description':
              GitGistCacheManager.configDescription ?? 'gitbbs auto generate',
          'files': map
        },
        Method.PATCH);
  }

  @override
  Request getLabelsConfig() {
    return Request('/repos/$owner/$repoName/contents/label.json',
        {'ref': 'master'}, Method.GET);
  }
}
