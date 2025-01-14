﻿FROM mcr.microsoft.com/dotnet/runtime-deps:6.0-alpine AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build
WORKDIR /src
COPY ["DemoApi.csproj", "./"]
RUN dotnet restore "DemoApi.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "DemoApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DemoApi.csproj" -c Release -o /app/publish \
   -r alpine-x64 \
   --self-contained true \
   -p:PublishTrimmed=true \
   -p:PublishSingleFile=true

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["./DemoApi"]
