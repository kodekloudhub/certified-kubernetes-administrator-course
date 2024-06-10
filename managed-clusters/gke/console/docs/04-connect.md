# Connect to Cluster

1. When the cluster has deployed, then there will be a green tick in the status column. You can now click on the cluster name<br/><br/>![select](../images/04-select.png)
1. At the top of the following screen, click on `CONNECT`<br/><br/>![connect](../images/04-connect.png)
1. Click on `RUN IN CLOUDSHELL`. The CloudShell pane will open at the bottom of the screen. Press the `CONTINUE` button.<br/><br/>![cloudshell](../images/04-run-in-cloudshell.png)
1. The terminal will open and some commands will appear in it, Hit `ENTER` to execute them. Press `AUTHORIZE` on the dialog that pops up.<br/><br/>![terminal](../images/04-terminal.png)
1. Test with `kubectl`

    ```text
    kubectl get pods -A
    ```


