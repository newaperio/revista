import React from "react";

class TweetList extends React.Component {
  constructor(props) {
    super(props);
    this.state = { tweets: [] };
  }

  componentDidMount() {
    this.props.channel.on("tweets_refreshed", payload =>
      this.setState({ tweets: payload.tweets })
    );
  }

  render() {
    return (
      <React.Fragment>
        {this.state.tweets.map(tweet => (
          <div key={tweet.id} class="card mb-3">
            <div class="card-body">{tweet.text}</div>
          </div>
        ))}
      </React.Fragment>
    );
  }
}

export default TweetList;
