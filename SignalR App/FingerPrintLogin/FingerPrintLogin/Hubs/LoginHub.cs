using Microsoft.AspNetCore.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace FingerPrintLogin.Hubs
{
    public class LoginHub : Hub
    {
       
        public async Task RequestLogin(string email, string password)
        {
            await Clients.All.SendAsync("NewLoginRequest",Context.ConnectionId);
        }
        public async Task GrantLogin(string result, string connectionId)
        {
            await Clients.Client(connectionId).SendAsync("LoginResult", result);
        }
    }
}
